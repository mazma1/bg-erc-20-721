// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract DOLToken is IERC20 {
    uint8 public decimals = 18;
    string public symbol = "DOL";
    string public name = "DoLittle";

    uint DOLTokenPerEther = 1000;

    uint supply = 1000000 * (10 ** decimals);

    mapping(address => uint256) public balanceList; // [ownerAddress ==> tokenBalance]
    mapping(address => mapping(address => uint256)) public approvalList; // [ownerAddress ==> [approvedDelegate ==> amountApproved]]

    constructor() {
        // the user who deploys the contract (contractOwner) gets total supply
        balanceList[msg.sender] = supply;
    }

    function totalSupply() public override view returns (uint256) {
        return supply;
    }

    function balanceOf(address tokenOwner) public override view returns (uint) {
        return balanceList[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        // require(balanceList[msg.sender] >= numTokens, "Insufficient balance")

        balanceList[msg.sender] -= numTokens;
        balanceList[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns(bool) {
        require(balanceList[msg.sender] >= numTokens, "Insufficient balance");

        approvalList[msg.sender][delegate] += numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view override returns(uint256) {
        uint256 tokensApprovedForWithdrawal = approvalList[owner][delegate];
        return tokensApprovedForWithdrawal;
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns(bool) {
        require(balanceList[owner] >= numTokens, "Insufficient balance");
        require(approvalList[owner][msg.sender] >= numTokens, "Specified number of tokens not approved for withdrawal");

        approvalList[owner][msg.sender] -= numTokens;
        balanceList[owner] -= numTokens;
        balanceList[buyer] += numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function buyToken(address receiver) public payable returns(uint) {
        uint256 numTokens = msg.value/10^18 * DOLTokenPerEther;
        transfer(receiver, numTokens);

        supply += numTokens;
        return supply;
    }
}
