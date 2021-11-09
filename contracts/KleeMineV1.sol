// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

import {SafeMath} from '@openzeppelin/contracts/utils/math/SafeMath.sol';
import {SafeCast} from '@openzeppelin/contracts/utils/math/SafeCast.sol';


contract KleeMine is Ownable {
    using SafeMath for uint256;
    using SafeCast for uint256;

    struct PoolInfo {
        address TokenA;
        address TokenB;
        uint256 totalStake;
    }
    struct UserInfo {
        uint256 TokenAAmount;
        uint256 TokenBAmount;
    }


    PoolInfo[] pools;

    mapping(uint256 => mapping(address => UserInfo)) internal userInfo;

    contract RewardLockerInterface {
        function deposit(uint256 amount); 
    } 

    address _RewardLockerAddress;
    RewardLockerInterface private _RewardLocker;

    constructor()  {
    }

    function setRewardLockerAddress(address newRL) external onlyOwner {
        _RewardLockerAddress = address(newRL);
        _RewardLocker = RewardLockerInterface(_RewardLockerAddress)
    }

    function addPool(address tokenA, address tokenB) public {
        pools.push(PoolInfo(tokenA,tokenB,0));
    }

    function _deposit(address _tokenAddr,uint256 amount) public payable {
        //transfer the money from certain coins to the pools
        if (_tokenAddr == 0)  {//native token- eth
            //the amount of eth send here will be given to the contract
        } else {
            _thatToken = IERC20(_tokenAddr);
            _thatToken.transferFrom(_msgSender(),address(this),amount);
        }

    }

    function _withdraw(address _tokenAddr) internal {
        if (_tokenAddr == 0)  {//native token- eth
            payable(_msgSender()).transfer(AMOUNT);
        } else {
            _thatToken = IERC20(_address);
            _thatToken.transfer(_msgSender(),AMOUNT);
        }
    }
    function stake(uint256 poolID,uint256 amountA, uint256 amountB) public {
        require(poolID < pools.length);
        _deposit(pools[poolID].TokenA,amountA,poolID);
        _deposit(pools[poolID].TokenB,amountB,poolID);
        userInfo[poolID][_msgSender()].TokenAAmount.add(amountA);
        userInfo[poolID][_msgSender()].TokenBAmount.add(amountB);
        //for now we record everything in eth -- also making the tokenA in the pair an eth for
        //ease of implementation
        
        if (pools[poolID].totalStake != 0) {
            _RewardLocker.deposit(amountA,amountA.div(pools[poolID].totalStake.mul(100)));
        }
        pools[poolID].totalStake.add(amountA);
    }

    function withdraw(uint256 poolID,uint256 amountA, uint256 amountB) public {
        require(poolID < pools.length);
        _withdraw(pools[poolID].TokenA,amountA,poolID);
        _withdraw(pools[poolID].TokenB,amountB,poolID);
        userInfo[poolID][_msgSender()].TokenAAmount.sub(amountA);
        userInfo[poolID][_msgSender()].TokenBAmount.sub(amountB);

        pools[poolID].totalStake.sub(amountA);

     }
}