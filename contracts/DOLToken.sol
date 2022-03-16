// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./IERC20.sol";

contract DOLToken is IERC20 {
    string public name = "DoLittle";
    string public symbol = "DOL";
    uint public decimals = 18;
    uint DOLTokenPrice = 1 ether; // 1 ether = 1000 Tokens

    uint public override totalSupply = 1000000 * (10 ** decimals);

    constructor() {
        // the user who deploys the contract gets total supply
        balanceOf[msg.sender] = totalSupply;
    }

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public approved;

    function transfer(address to, uint256 amount) public override returns (bool) {
        // require(balanceOf[msg.sender] >= amount, "Insufficient balance")
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns(uint256) {
        uint256 amount = approved[owner][spender];
        return amount;
    }

    function approve(address spender, uint256 amount) public override returns(bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        approved[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public override returns(bool) {
        require(approved[from][msg.sender] >= amount, "Amount not approved");
        approved[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function buyToken(address receiver) public payable {
        require(msg.value == DOLTokenPrice, "Sale price is 1 ether for 1000DOL");
        transferFrom(msg.sender, receiver, 1000);
    }
}
