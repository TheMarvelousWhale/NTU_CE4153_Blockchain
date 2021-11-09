// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
import {SafeMath} from '@openzeppelin/contracts/utils/math/SafeMath.sol';
import {SafeCast} from '@openzeppelin/contracts/utils/math/SafeCast.sol';

contract YM2 is ERC20("YuaMikVer2","YM2"), Ownable {
    using SafeMath for uint256;
    using SafeCast for uint256;

    uint256 internal exchangeRate = 1 ;  //1 YM2 to 1 ETH

    constructor() public {
        _mint(msg.sender, 1000* (10 ** uint256(decimals())));
        _mint(address(this),1000 * (10 ** uint256(decimals())));   
    }

    function buyCoin() public payable {
        //TODO: figure out how to get the ether amount to this address, and convert it to token
        _transfer(address(this),msg.sender,msg.value * exchangeRate);
    }

    function setExchangeRate(uint256 newExchangeRate) public onlyOwner {
        exchangeRate = newExchangeRate;
    }
    function getExchangeRate() public view returns (uint256) {
        return exchangeRate;
    }
    function getEtherBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function sellCoin(uint256 amount) public {
        _transfer(_msgSender(),address(this), amount * (10 ** uint256(decimals())));
        payable(_msgSender()).transfer((amount/exchangeRate) * 1 ether);
    }
}