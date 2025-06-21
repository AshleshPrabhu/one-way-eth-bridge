
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { console } from "forge-std/console.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeETH  is Ownable{
    address public tokenAddress;
    uint public balance;
    mapping (address=>uint) pendingBalance;
    event Deposit(address indexed depositor, uint amount);

    constructor(address _tokenAddress)Ownable(msg.sender){
        tokenAddress = _tokenAddress;
    }

    function deposit(IERC20 _tokenAddress,uint _amount)public{
        require(address(_tokenAddress)==tokenAddress);
        require(_tokenAddress.allowance(msg.sender, address(this))>=_amount);
        require(_tokenAddress.transferFrom(msg.sender, address(this), _amount));
        balance+=_amount;
        emit Deposit(msg.sender, _amount);
    }

    function  withdraw(IERC20 _tokenAddress, uint _amount) public{
        require(address(_tokenAddress)==tokenAddress);
        require(pendingBalance[msg.sender]>=_amount);
        require(_tokenAddress.transfer(msg.sender, _amount));
        pendingBalance[msg.sender] -= _amount;
        balance-=_amount;
    }

    function burnedOnOppositeChain(address _burner,uint _amount) public onlyOwner{
        pendingBalance[_burner]+=_amount;
    }

}