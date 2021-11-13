// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

import {SafeMath} from '@openzeppelin/contracts/utils/math/SafeMath.sol';
import {SafeCast} from '@openzeppelin/contracts/utils/math/SafeCast.sol';

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";



//@dev: this token is the reward NFT for providing liquidity to the pools
//    : only claimable via the pool stake token
contract KleeTokenV6 is ERC721URIStorage, Ownable {
    using SafeMath for uint256;
    using SafeCast for uint256;


    uint256 tokenCounter;
    mapping (uint256 => address) tokenToOwner; 

    IERC20 private _RewardToken;
    address _RewardTokenAddress = address(0x97Fd477e1893a2eEDcC7DEFE19fcDA7bF3EB6F1f);

    constructor() ERC721("KleeTokenV6", "KT6") {
        _RewardToken = IERC20(_RewardTokenAddress);
        tokenCounter = 0;
    }

    //@dev: when the LP has harvested enough reward token to exchange for an nft
    //    : this function will be called by owner, with the amount of token needed for the nft set by front-end
    //    : for e.g if legendary tier NFT is to be minted, amount should be large
    //    : backend doesnt do that stuff
    function awardNFT(string memory tokenURI,uint256 amount,address rewardeeAddress) public onlyOwner {
        //our id starts from 1 cuz matlab
        tokenCounter = tokenCounter.add(1);  
        _safeMint(_msgSender(), tokenCounter);
        _setTokenURI(tokenCounter, tokenURI);
        _RewardToken.transferFrom(rewardeeAddress,address(this),amount);  
    }



    function setRewardTokenAddress(address _newRewardToken) external onlyOwner {
        _RewardTokenAddress = address(_newRewardToken);
        _RewardToken = IERC20(_RewardTokenAddress);
    }
}
