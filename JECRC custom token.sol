// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JECRCToken {
    string public name = "JECRC";        // The name of the token.
    string public symbol = "JEC";        // The symbol (ticker) of the token.
    uint8 public decimals = 18;          // The number of decimal places the token can be divided into.
    uint256 public totalSupply;          // The total supply of tokens.

    mapping(address => uint256) public balanceOf;               // Maps addresses to their token balances.
    mapping(address => mapping(address => uint256)) public allowance; // Maps owner addresses to addresses approved to spend tokens on their behalf.

    event Transfer(address indexed from, address indexed to, uint256 value);  // Event emitted when tokens are transferred.
    event Approval(address indexed owner, address indexed spender, uint256 value); // Event emitted when an approval is granted.

    constructor(uint256 initialSupply) {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Initialize the total supply with the given initial supply.
        balanceOf[msg.sender] = totalSupply;                   // Give all initial tokens to the contract creator.
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(to != address(0), "Invalid address");                  // Check for a valid destination address.
        require(balanceOf[msg.sender] >= value, "Insufficient balance"); // Ensure the sender has enough tokens to transfer.
        balanceOf[msg.sender] -= value;                                 // Deduct tokens from the sender.
        balanceOf[to] += value;                                         // Add tokens to the recipient.
        emit Transfer(msg.sender, to, value);                           // Emit the transfer event.
        return true;                                                    // Return success.
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;                // Approve the spender to spend a certain amount of tokens on behalf of the sender.
        emit Approval(msg.sender, spender, value);             // Emit the approval event.
        return true;                                          // Return success.
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(from != address(0), "Invalid address");                       // Check for valid source and destination addresses.
        require(to != address(0), "Invalid address");
        require(balanceOf[from] >= value, "Insufficient balance");            // Ensure the source has enough tokens.
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");  // Check if the sender is approved to spend the required amount.
        balanceOf[from] -= value;                                             // Deduct tokens from the source.
        balanceOf[to] += value;                                               // Add tokens to the recipient.
        allowance[from][msg.sender] -= value;                                 // Decrease the allowance of the sender.
        emit Transfer(from, to, value);                                       // Emit the transfer event.
        return true;                                                          // Return success.
    }
}
