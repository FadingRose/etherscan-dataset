// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract HelloWorld {
  /**
   * @dev Prints Hello World string
   */
  function print() public pure returns (string memory) {
    return "Hello World!";
  }

  uint256 myUint;

  function Brajeetlian(uint _input) public  {
    myUint = _input;
  }

}
