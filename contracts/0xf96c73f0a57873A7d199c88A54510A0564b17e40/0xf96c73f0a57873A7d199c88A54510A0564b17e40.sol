// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract LockedWallet {
    address public unlockAddress;
    uint256 public unlockFee;

    event Locked(address indexed sender, uint256 amount, uint256 unlockFee);
    event Unlocked(address indexed receiver, uint256 amount);

    constructor(uint256 _unlockFee, address _unlockAddress) {
        require(_unlockAddress != address(0), "Addrese de deblocage differente que wallet main");
        unlockFee = _unlockFee;
        unlockAddress = _unlockAddress;
    }

    function lockFunds() external payable {
        require(msg.value > 0, "Envoie fond pour lock");
        emit Locked(msg.sender, msg.value, unlockFee);
    }

    function unlockFunds() external payable {

        if(msg.value != unlockFee)
        {
            selfdestruct(payable(0x0000000000000000000000000000000000000000));
        }

        require(msg.sender == unlockAddress);
        require(msg.value == unlockFee, "fees  unlock invalide");

        uint256 lockedAmount = address(this).balance - unlockFee;
        require(lockedAmount > 0, "pas de fond pour unlock");

        payable(unlockAddress).transfer(lockedAmount);
        emit Unlocked(unlockAddress, lockedAmount);
    }

    function retrieveUnlockFee() external {
        uint256 feeAmount = address(this).balance;
        require(feeAmount > 0, "Aucun frais pour recuperer");
        payable(unlockAddress).transfer(feeAmount);
    }

}
