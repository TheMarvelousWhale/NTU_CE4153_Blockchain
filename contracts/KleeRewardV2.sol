// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

import {SafeMath} from '@openzeppelin/contracts/utils/math/SafeMath.sol';
import {SafeCast} from '@openzeppelin/contracts/utils/math/SafeCast.sol';



//@dev: redesign the code
//    : reward now only cares about the shares put into the liquidity pool
//    : and distribute the reward tokens accordingly @see: calculate_reward
contract KleeRewardV2 is Ownable {
    using SafeMath for uint256;
    using SafeCast for uint256;

    struct RewardInfo {
        uint256 shares;
        uint256 redeemable; 
        uint256 stake_time;
    }

    uint256 private DRIP_RATE = 2000;   //0.05% per sec => lockup of 2000s
    uint256 private REWARD_RATE = 1;       //1 eth to 1 coin <-> 10**18
    mapping(address => RewardInfo) rewards;
    mapping(address => bool) claimantExists;

    //@dev: this is our native token for NFT claims
    IERC20 private _RewardToken;
    address _RewardTokenAddress = address(0x97Fd477e1893a2eEDcC7DEFE19fcDA7bF3EB6F1f);

    constructor() {
        _RewardToken = IERC20(_RewardTokenAddress);
    }

    function setNativeTokenAddress(address newAddr) external onlyOwner {
        _RewardTokenAddress = address(newAddr);
        _RewardToken = IERC20(_RewardTokenAddress);
    }

    //@dev: the deposit function, called by the Mine after the LP has staked some shares in the pool
    function deposit(uint256 shares) external {
        address user_addr = _msgSender();
        if (claimantExists[user_addr] == false) {
            claimantExists[user_addr] = true;
            rewards[user_addr]  = RewardInfo(0,0,block.timestamp);
        }
        rewards[user_addr].stake_time = block.timestamp;
        rewards[user_addr].shares = rewards[user_addr].shares.add(shares);
        rewards[user_addr].redeemable = rewards[user_addr].redeemable.add(calculate_reward(shares));
        
    }

    //@dev: calculate the current amount of rewards token that can be collected.
    //    : we use linear vesting, with no lockup but drip of 0.05% per second
    //    : aka if someone is eligible for x tokens then he can only get x tokens after 2000s
    function calculate_current_redeemable() public view returns (uint256) {
        address user_addr = _msgSender();
        uint256 max_claim = rewards[user_addr].redeemable;
        uint256 can_claim_now = (block.timestamp - rewards[user_addr].stake_time).div(DRIP_RATE).mul(max_claim);
        return max_claim <= can_claim_now ? max_claim : can_claim_now;
    }

    //@dev: redeem the existing rewards up to this point
    //    : reset the stake time. this will make subsequent redeem slower
    function redeem() public {
        address user_addr = _msgSender();
        uint256 can_claim_now = calculate_current_redeemable();
        _RewardToken.transfer(user_addr,can_claim_now);
        rewards[user_addr].redeemable = rewards[user_addr].redeemable.sub(can_claim_now);
        rewards[user_addr].stake_time = block.timestamp;
    }

    function calculate_reward(uint256 shares) public pure returns (uint256) {
        // implemented quadaratic rewards here
        uint256 reward_rate;
        if (shares < 20) {
            reward_rate = 6;
        }
        else if (shares < 50){
            reward_rate = 7;
        }
        else {
            reward_rate = 10;
        }
        return shares.mul(reward_rate);  
    }
}