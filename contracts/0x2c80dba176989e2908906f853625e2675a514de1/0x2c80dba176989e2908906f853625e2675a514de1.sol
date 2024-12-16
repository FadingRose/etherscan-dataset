// Sources flattened with hardhat v2.22.6 https://hardhat.org

// SPDX-License-Identifier: MIT

// File contracts/Subscription.sol

// Original license: SPDX_License_Identifier: MIT

pragma solidity >= 0.7.0 < 0.9.0;

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

interface IMevrora {
  function allowance ( address _owner, address spender ) external view returns ( uint256 );
  function approve ( address spender, uint256 amount ) external returns ( bool );
  function balanceOf ( address account ) external view returns ( uint256 );
  function decimals (  ) external view returns ( uint8 );
  function decreaseAllowance ( address spender, uint256 subtractedValue ) external returns ( bool );
  function editFees ( uint256 _feeBuy, uint256 _feeSell ) external;
  function editSwapPair ( address adr ) external;
  function editWallets ( address _marketingWallet, address _teamWallet ) external;
  function feeBuy (  ) external view returns ( uint256 );
  function feeSell (  ) external view returns ( uint256 );
  function increaseAllowance ( address spender, uint256 addedValue ) external returns ( bool );
  function marketingWallet (  ) external view returns ( address );
  function mint ( address account, uint256 amount ) external;
  function name (  ) external view returns ( string memory );
  function owner (  ) external view returns ( address );
  function swapPair (  ) external view returns ( address );
  function symbol (  ) external view returns ( string memory );
  function teamWallet (  ) external view returns ( address );
  function totalSupply (  ) external view returns ( uint256 );
  function transfer ( address recipient, uint256 amount ) external returns ( bool );
  function transferFrom ( address sender, address recipient, uint256 amount ) external returns ( bool );
}


contract Subscription {
    using SafeMath for uint;

    address public owner;
    address public mevrora;
    address public devrora;
    uint256 public tax;
    address public swap;
    uint public holdTarget;

    struct holder {
        address payable holderAddr;
        uint256 amount;
        bool temp;
    }

    constructor(address _devrora, address _mevrora, uint256 _tax, address _swap) {
        owner = msg.sender;
        devrora = _devrora;
        mevrora = _mevrora;
        tax = _tax;
        swap = _swap;
        holdTarget = 1 ether;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not an owner");
        _;
    }

    receive() external payable {
        if (address(this).balance >= holdTarget) {
            distribute();
        }
    }

    function transferOwnership(address account) external onlyOwner {
        require(account != address(0), "Wrong address!");
        owner = account;
    }

    function deposit() external payable {
        if (address(this).balance >= holdTarget) {
            distribute();
        }
    }

    function changeHoldTarget(uint _value) external onlyOwner {
        (bool success, bytes memory data) = devrora.call(abi.encodeWithSignature("enoughConfirms()"));

        if (success) {
            (bool confirmed) = abi.decode(data, (bool));
            if (!confirmed) {
                return;
            }
            holdTarget = _value;
        }
    }

    function getSwap() external view returns(address) {
        return swap;
    }

    function changeSwap(address _swap) external onlyOwner {
        swap = _swap;
    }

    function distributeProjTokens() external onlyOwner {
        (bool success, bytes memory data) = devrora.call(abi.encodeWithSignature("calcDistribution()"));
        
        if (success) {
            (holder[] memory _holders) = abi.decode(data, (holder[]));

            uint256 _balance = IMevrora(mevrora).balanceOf(address(this));

            IMevrora(mevrora).transfer(swap, _balance.mul(tax).div(100));
            
            _balance = IMevrora(mevrora).balanceOf(address(this));
            for (uint i = 0; i < _holders.length; i++) {
                IMevrora(mevrora).transfer(_holders[i].holderAddr, _balance.mul(_holders[i].amount).div(100));
            }
        }
    }

    function changeTax(uint _tax) external onlyOwner {
        require(_tax <= 100, "incorrect tax value");

        (bool success, bytes memory data) = devrora.call(abi.encodeWithSignature("enoughConfirms()"));

        if (success) {
            (bool confirmed) = abi.decode(data, (bool));
            if (!confirmed) {
                revert("Not enough confirms from devrora holders");
            }
            tax = _tax;
        }
    }


    function distribute() internal {
        (bool success, bytes memory data) = devrora.call(abi.encodeWithSignature("calcDistribution()"));

        if (success) {
            (holder[] memory _holders) = abi.decode(data, (holder[]));

            uint256 _balance = address(this).balance;

            payable(swap).transfer(_balance.mul(tax).div(100));

            _balance = address(this).balance;
            for (uint i = 0; i < _holders.length; i++) {
                _holders[i].holderAddr.transfer(_balance.mul(_holders[i].amount).div(100));
            }
        }
    }
}
