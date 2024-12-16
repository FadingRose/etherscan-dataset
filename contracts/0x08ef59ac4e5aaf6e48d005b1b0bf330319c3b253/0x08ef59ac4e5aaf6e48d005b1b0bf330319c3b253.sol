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

contract HoPo_PiPo {
    string public constant NAME = "HoPo PiPo";
    string public constant SYMBOL = "PIPO";
    uint8 public constant DECIMALS = 18;
    uint256 public constant TOTAL_SUPPLY = 123456000 * (10 ** uint256(DECIMALS));

    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
        emit OwnershipTransferred(_owner, address(0));
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
}
