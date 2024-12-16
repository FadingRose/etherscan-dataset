//SPDX-License-Identifier: MIT

/*
 * The unluckiest hippo in the world, meet Hopo Pipo !
 * Hopo will be next meme revolution, you too be part of the Hopo pack !
 * 
 * This is a promotional contract, the $HOPO token will be launched on the 30st of July at 4pm UTC. 
 * 
 * Check out our socials for all the information !
 * TG : https://t.me/HopoPipoPortal
 * Website : http://hopo-pipo.com/?v1
 * X : https://x.com/HopoPipo
 * May the Hopo Pipo spirit be with you!
*/

pragma solidity ^0.8.1;

contract HOPO {
    string public constant NAME = "HOPO WORLD";
    string public constant SYMBOL = "HOPO";
    uint8 public constant DECIMALS = 18;
    uint256 public constant TOTAL_SUPPLY = 7666999000 * (10 ** uint256(DECIMALS));

    mapping(address => uint256) private _balances;
    event Transfer(address indexed from, address indexed to, uint256 value);
	
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _balances[msg.sender] = TOTAL_SUPPLY;
        emit Transfer(address(0), msg.sender, TOTAL_SUPPLY);
        emit OwnershipTransferred(address(0), msg.sender);
        emit OwnershipTransferred(msg.sender, address(0));
    }

    function totalSupply() public pure returns (uint256) {
        return TOTAL_SUPPLY;
    }

    function name() public pure returns (string memory) {
        return NAME;
    }

    function symbol() public pure returns (string memory) {
        return SYMBOL;
    }

    function decimals() public pure returns (uint8) {
        return DECIMALS;
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function min(uint256 a, uint256 b) private pure returns (uint256){
      return (a>b)?b:a;
    }
}
