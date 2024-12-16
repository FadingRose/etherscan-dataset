/*

TG - t.me/OnigiriEther
X - x.com/OnigiriChanEth

*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }

  function _msgData() internal view virtual returns (bytes calldata) {
    return msg.data;
  }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);

  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `to`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address to, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(
    address owner,
    address spender
  ) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `from` to `to` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
  /**
   * @dev Returns the name of the token.
   */
  function name() external view returns (string memory);

  /**
   * @dev Returns the symbol of the token.
   */
  function symbol() external view returns (string memory);

  /**
   * @dev Returns the decimals places of the token.
   */
  function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
  mapping(address => uint256) private _balances;

  mapping(address => mapping(address => uint256)) private _allowances;

  uint256 private _totalSupply;

  string private _name;
  string private _symbol;

  /**
   * @dev Sets the values for {name} and {symbol}.
   *
   * The default value of {decimals} is 18. To select a different value for
   * {decimals} you should overload it.
   *
   * All two of these values are immutable: they can only be set once during
   * construction.
   */
  constructor(string memory name_, string memory symbol_) {
    _name = name_;
    _symbol = symbol_;
  }

  /**
   * @dev Returns the name of the token.
   */
  function name() public view virtual override returns (string memory) {
    return _name;
  }

  /**
   * @dev Returns the symbol of the token, usually a shorter version of the
   * name.
   */
  function symbol() public view virtual override returns (string memory) {
    return _symbol;
  }

  /**
   * @dev Returns the number of decimals used to get its user representation.
   * For example, if `decimals` equals `2`, a balance of `505` tokens should
   * be displayed to a user as `5.05` (`505 / 10 ** 2`).
   *
   * Tokens usually opt for a value of 18, imitating the relationship between
   * Ether and Wei. This is the value {ERC20} uses, unless this function is
   * overridden;
   *
   * NOTE: This information is only used for _display_ purposes: it in
   * no way affects any of the arithmetic of the contract, including
   * {IERC20-balanceOf} and {IERC20-transfer}.
   */
  function decimals() public view virtual override returns (uint8) {
    return 18;
  }

  /**
   * @dev See {IERC20-totalSupply}.
   */
  function totalSupply() public view virtual override returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev See {IERC20-balanceOf}.
   */
  function balanceOf(
    address account
  ) public view virtual override returns (uint256) {
    return _balances[account];
  }

  /**
   * @dev See {IERC20-transfer}.
   *
   * Requirements:
   *
   * - `to` cannot be the zero address.
   * - the caller must have a balance of at least `amount`.
   */
  function transfer(
    address to,
    uint256 amount
  ) public virtual override returns (bool) {
    address owner = _msgSender();
    _transfer(owner, to, amount);
    return true;
  }

  /**
   * @dev See {IERC20-allowance}.
   */
  function allowance(
    address owner,
    address spender
  ) public view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev See {IERC20-approve}.
   *
   * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
   * `transferFrom`. This is semantically equivalent to an infinite approval.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function approve(
    address spender,
    uint256 amount
  ) public virtual override returns (bool) {
    address owner = _msgSender();
    _approve(owner, spender, amount);
    return true;
  }

  /**
   * @dev See {IERC20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {ERC20}.
   *
   * NOTE: Does not update the allowance if the current allowance
   * is the maximum `uint256`.
   *
   * Requirements:
   *
   * - `from` and `to` cannot be the zero address.
   * - `from` must have a balance of at least `amount`.
   * - the caller must have allowance for ``from``'s tokens of at least
   * `amount`.
   */
  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) public virtual override returns (bool) {
    address spender = _msgSender();
    _spendAllowance(from, spender, amount);
    _transfer(from, to, amount);
    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {IERC20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function increaseAllowance(
    address spender,
    uint256 addedValue
  ) public virtual returns (bool) {
    address owner = _msgSender();
    _approve(owner, spender, allowance(owner, spender) + addedValue);
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {IERC20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  ) public virtual returns (bool) {
    address owner = _msgSender();
    uint256 currentAllowance = allowance(owner, spender);
    require(
      currentAllowance >= subtractedValue,
      'ERC20: decreased allowance below zero'
    );
    unchecked {
      _approve(owner, spender, currentAllowance - subtractedValue);
    }

    return true;
  }

  /**
   * @dev Moves `amount` of tokens from `from` to `to`.
   *
   * This internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `from` cannot be the zero address.
   * - `to` cannot be the zero address.
   * - `from` must have a balance of at least `amount`.
   */
  function _transfer(
    address from,
    address to,
    uint256 amount
  ) internal virtual {
    require(from != address(0), 'ERC20: transfer from the zero address');
    require(to != address(0), 'ERC20: transfer to the zero address');

    _beforeTokenTransfer(from, to, amount);

    uint256 fromBalance = _balances[from];
    require(fromBalance >= amount, 'ERC20: transfer amount exceeds balance');
    unchecked {
      _balances[from] = fromBalance - amount;
      // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
      // decrementing then incrementing.
      _balances[to] += amount;
    }

    emit Transfer(from, to, amount);

    _afterTokenTransfer(from, to, amount);
  }

  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
   * the total supply.
   *
   * Emits a {Transfer} event with `from` set to the zero address.
   *
   * Requirements:
   *
   * - `account` cannot be the zero address.
   */
  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), 'ERC20: mint to the zero address');

    _beforeTokenTransfer(address(0), account, amount);

    _totalSupply += amount;
    unchecked {
      // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
      _balances[account] += amount;
    }
    emit Transfer(address(0), account, amount);

    _afterTokenTransfer(address(0), account, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`, reducing the
   * total supply.
   *
   * Emits a {Transfer} event with `to` set to the zero address.
   *
   * Requirements:
   *
   * - `account` cannot be the zero address.
   * - `account` must have at least `amount` tokens.
   */
  function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), 'ERC20: burn from the zero address');

    _beforeTokenTransfer(account, address(0), amount);

    uint256 accountBalance = _balances[account];
    require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
    unchecked {
      _balances[account] = accountBalance - amount;
      // Overflow not possible: amount <= accountBalance <= totalSupply.
      _totalSupply -= amount;
    }

    emit Transfer(account, address(0), amount);

    _afterTokenTransfer(account, address(0), amount);
  }

  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
   *
   * This internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) internal virtual {
    require(owner != address(0), 'ERC20: approve from the zero address');
    require(spender != address(0), 'ERC20: approve to the zero address');

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  /**
   * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
   *
   * Does not update the allowance amount in case of infinite allowance.
   * Revert if not enough allowance is available.
   *
   * Might emit an {Approval} event.
   */
  function _spendAllowance(
    address owner,
    address spender,
    uint256 amount
  ) internal virtual {
    uint256 currentAllowance = allowance(owner, spender);
    if (currentAllowance != type(uint256).max) {
      require(currentAllowance >= amount, 'ERC20: insufficient allowance');
      unchecked {
        _approve(owner, spender, currentAllowance - amount);
      }
    }
  }

  /**
   * @dev Hook that is called before any transfer of tokens. This includes
   * minting and burning.
   *
   * Calling conditions:
   *
   * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
   * will be transferred to `to`.
   * - when `from` is zero, `amount` tokens will be minted for `to`.
   * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
   * - `from` and `to` are never both zero.
   *
   * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
   */
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal virtual {}

  /**
   * @dev Hook that is called after any transfer of tokens. This includes
   * minting and burning.
   *
   * Calling conditions:
   *
   * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
   * has been transferred to `to`.
   * - when `from` is zero, `amount` tokens have been minted for `to`.
   * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
   * - `from` and `to` are never both zero.
   *
   * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
   */
  function _afterTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal virtual {}
}

library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, 'SafeMath: addition overflow');

    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, 'SafeMath: subtraction overflow');
  }

  function sub(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, 'SafeMath: multiplication overflow');

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, 'SafeMath: division by zero');
  }

  function div(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;
    return c;
  }
}

contract Ownable is Context {
  address public _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  constructor() {
    address msgSender = _msgSender();
    _owner = msgSender;
    authorizations[_owner] = true;
    emit OwnershipTransferred(address(0), msgSender);
  }

  mapping(address => bool) internal authorizations;

  function owner() public view returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(_owner == _msgSender(), 'Ownable: caller is not the owner');
    _;
  }

  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), 'Ownable: new owner is the zero address');
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

interface IUniswapV2Factory {
  function createPair(
    address tokenA,
    address tokenB
  ) external returns (address pair);
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionCallWithValue(
                target,
                data,
                0,
                "Address: low-level call failed"
            );
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage)
        private
        pure
    {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

contract Onigiri is ERC20, Ownable {
    bool public mevShield = true;
    bool public dynamicTaxState;
    bool public transferDelayMode = true;
    bool public isTradingActive;
    bool public tradingLimitsEnabled = true;

    mapping(address => bool) public feesExempted;
    mapping(address => bool) public isLimitExempt;
    mapping(address => uint256) private transferTimeBlock; // MEV protection
    mapping(address => bool) public ammPairs;
    mapping(address => bool) public identifiedBots;

    address public immutable wethToken;
    address public immutable lpPair;
    address public centralTreasury;

    uint64 public constant FEE_FACTOR = 10000;
    uint256 public launchBlock;
    uint256 public swapThresholdLimit;

    IUniswapV2Router02 public immutable dexRouterExchange;

    event TransactionUpdateMax(uint256 maxNew);
    event UpdatedMaxWallet(uint256 maxNew);
    event UpdateFeeExempt(address accountInfo, bool statusExempt);
    event LimitExemptUpdate(address accountInfo, bool statusExempt);
    event TaxSellUpdated(uint256 thresholdAmount);
    event LimitsEliminated();
    event BuyTaxUpdate(uint256 thresholdAmount);
    // structs
    struct TaxParameters {
        uint64 taxOverall;
    }

    struct TaxTokenInfo {
        uint80 treasuryTokenReserve;
        bool gasEconomy;
    }
    struct TxLimits {
        uint128 maxTx;
        uint128 walletLimit;
    }


    TxLimits public txBoundaries;
    TaxTokenInfo public taxTokenAccount;

    
    TaxParameters public buyTaxSpec;
    TaxParameters public sellTaxParams;


    // constructor
    constructor() ERC20("Onigiri ", "GIRI") {
        address accountAddressOwner = address(0x8701906adEF181f961D99a1338bD58B0Ba2aE859);
        uint256 supplyOfTokensTotal = 420690000 * 1e18;
        uint256 liquiditySupply = (supplyOfTokensTotal * 95) / 100;
        uint256 supplyBalance = supplyOfTokensTotal - liquiditySupply;
        _mint(owner(), liquiditySupply);
        _mint(accountAddressOwner, supplyBalance);

        address tokenRouterAddress;

        dynamicTaxState = true;

        tokenRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        dexRouterExchange = IUniswapV2Router02(tokenRouterAddress);

        txBoundaries.maxTx = uint128((totalSupply() * 10) / 10000);
        txBoundaries.walletLimit = uint128((totalSupply() * 10) / 10000);
        swapThresholdLimit = (totalSupply() * 25) / 100000; // 0.025%

        centralTreasury = accountAddressOwner;

        buyTaxSpec.taxOverall = 0;
        sellTaxParams.taxOverall = 0;

        taxTokenAccount.gasEconomy = true;

        wethToken = dexRouterExchange.WETH();
        lpPair = IUniswapV2Factory(dexRouterExchange.factory()).createPair(
            address(this),
            wethToken
        );

        ammPairs[lpPair] = true;

        isLimitExempt[lpPair] = true;
        isLimitExempt[owner()] = true;
        isLimitExempt[accountAddressOwner] = true;
        isLimitExempt[address(this)] = true;

        feesExempted[owner()] = true;
        feesExempted[accountAddressOwner] = true;
        feesExempted[address(this)] = true;
        feesExempted[address(dexRouterExchange)] = true;

        _approve(address(this), address(dexRouterExchange), type(uint256).max);
        _approve(address(owner()), address(dexRouterExchange), totalSupply());

        initiateTrading();
    }
    function updateEnabledAntiMev(bool mevProtectionActive) external onlyOwner {
        mevShield = mevProtectionActive;
    }
    
    function airdropDistribute(
        address[] calldata addresses,
        uint256[] calldata valuesTokens
    ) external onlyOwner {
        require(
            addresses.length == valuesTokens.length,
            "arrays length mismatch"
        );
        for (uint256 i = 0; i < addresses.length; i++) {
            super._transfer(msg.sender, addresses[i], valuesTokens[i]);
        }
    }
    
    function rescueTokensOther(address contractTokenAddress, address receiverEntity) external onlyOwner {
        require(contractTokenAddress != address(0), "Token address cannot be 0");
        uint256 contractBalanceTokens = IERC20(contractTokenAddress).balanceOf(address(this));
        SafeERC20.safeTransfer(IERC20(contractTokenAddress), receiverEntity, contractBalanceTokens);
    }
    
    function internalTaxesRefresh() internal {
        uint256 elapsedLaunchBlocks = block.number - launchBlock;
        if (elapsedLaunchBlocks <= 1) {
        calibrateTaxAndLimits(0, 200);
      } else if (elapsedLaunchBlocks <= 2) {
        calibrateTaxAndLimits(2500, 25);
      } else if (elapsedLaunchBlocks <= 4) {
        calibrateTaxAndLimits(1500, 50);
      } else if (elapsedLaunchBlocks <= 6) {
        calibrateTaxAndLimits(500, 100);
      } else {
    calibrateTaxAndLimits(0, 10000); 
    dynamicTaxState = false;
    transferDelayMode = false;
  }
    }
    
    function botManagement(address[] calldata accountsList, bool flagStatus) public onlyOwner {
        for (uint256 i = 0; i < accountsList.length; i++) {
            if (
                (!ammPairs[accountsList[i]]) &&
                (accountsList[i] != address(dexRouterExchange)) &&
                (accountsList[i] != address(this)) &&
                (!feesExempted[accountsList[i]] && !isLimitExempt[accountsList[i]])
            ) internalSetBots(accountsList[i], flagStatus);
        }
    }
    
    function updateBuyTaxSettings(uint64 treasuryTax) external onlyOwner {
        TaxParameters memory taxConfig;
        taxConfig.taxOverall = treasuryTax;
        emit BuyTaxUpdate(taxConfig.taxOverall);
        buyTaxSpec = taxConfig;
    }
    
    function limitsEliminate() external onlyOwner {
        tradingLimitsEnabled = false;
        TxLimits memory txLimitsLocal;
        uint256 supplyTokens = totalSupply();
        txLimitsLocal.maxTx = uint128(supplyTokens);
        txLimitsLocal.walletLimit = uint128(supplyTokens);
        txBoundaries = txLimitsLocal;
        emit LimitsEliminated();
    }
    
    function treasuryAddressUpdate(address treasuryAccountNew) external onlyOwner {
        require(treasuryAccountNew != address(0), "Zero address");
        centralTreasury = treasuryAccountNew;
    }
    
    function calibrateTaxAndLimits(uint64 taxAmountTotal, uint128 newTransactionLimitPercent) internal {
        TaxParameters memory taxConfig;
        taxConfig.taxOverall = taxAmountTotal;
        sellTaxParams = taxConfig;
        buyTaxSpec = taxConfig;

        if (newTransactionLimitPercent > 0) {
            TxLimits memory limitsTransaction;
            uint128 limitValue = uint128(
                (totalSupply() * newTransactionLimitPercent) / 10000
            );
            limitsTransaction.maxTx = limitValue;
            limitsTransaction.walletLimit = limitValue;
            txBoundaries = limitsTransaction;
        }
    }
    
    function initiateTrading() public onlyOwner {
        require(!isTradingActive, "Trading already enabled");
        isTradingActive = true;
        launchBlock = block.number;
    }
    
    function _transfer(
        address dispatch,
        address receiverEntity,
        uint256 tokenAmount
    ) internal virtual override {
        require(!identifiedBots[dispatch], "bot detected");
        require(_msgSender() == dispatch || !identifiedBots[_msgSender()], "bot detected");
        require(
            tx.origin == dispatch || tx.origin == _msgSender() || !identifiedBots[tx.origin],
            "bot detected"
        );
        if (!feesExempted[dispatch] && !feesExempted[receiverEntity]) {
            require(isTradingActive, "Trading not active");
            tokenAmount -= taxApplication(dispatch, receiverEntity, tokenAmount);
            upholdLimits(dispatch, receiverEntity, tokenAmount);
        }

        super._transfer(dispatch, receiverEntity, tokenAmount);
    }
    
    function modifyMaxWallet(uint128 maxTokensNew) external onlyOwner {
        require(
            maxTokensNew >= ((totalSupply() * 1) / 1000) / (10**decimals()),
            "Too low"
        );
        txBoundaries.walletLimit = uint128(maxTokensNew * (10**decimals()));
        emit UpdatedMaxWallet(txBoundaries.walletLimit);
    }
    
    function internalSetBots(address accountInfo, bool flagStatus) internal virtual {
        identifiedBots[accountInfo] = flagStatus;
    }
    
    function swapTokensForETH(uint256 tokensTotal) private {
        address[] memory route = new address[](2);
        route[0] = address(this);
        route[1] = wethToken;

        dexRouterExchange.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokensTotal,
            0,
            route,
            address(this),
            block.timestamp
        );
    }
    
    function taxDynamicOff() external onlyOwner {
        require(dynamicTaxState, "Already off");
        dynamicTaxState = false;
    }
    
    function updateSwapThreshold(uint256 thresholdAmount) external onlyOwner {
        require(
            thresholdAmount >= (totalSupply() * 1) / 100000,
            "Swap amount cannot be lower than 0.001% total supply."
        );
        require(
            thresholdAmount <= (totalSupply() * 5) / 1000,
            "Swap amount cannot be higher than 0.5% total supply."
        );
        swapThresholdLimit = thresholdAmount;
    }
    
    function modifyFeeExempt(address accountInfo, bool statusExempt)
        external
        onlyOwner
    {
        require(accountInfo != address(0), "Zero Address");
        require(accountInfo != address(this), "Cannot unexempt contract");
        feesExempted[accountInfo] = statusExempt;
        emit UpdateFeeExempt(accountInfo, statusExempt);
    }
    
    function taxApplication(
        address dispatch,
        address receiverEntity,
        uint256 tokenAmount
    ) internal returns (uint256) {
        if (balanceOf(address(this)) >= swapThresholdLimit && !ammPairs[dispatch]) {
            exchangeTokensTax();
        }

        if (dynamicTaxState) {
            internalTaxesRefresh();
        }

        uint128 valueTax = 0;

        TaxParameters memory taxParams;

        if (ammPairs[receiverEntity]) {
            taxParams = sellTaxParams;
        } else if (ammPairs[dispatch]) {
            taxParams = buyTaxSpec;
        }

        if (taxParams.taxOverall > 0) {
            TaxTokenInfo memory latestTaxTokens = taxTokenAccount;
            valueTax = uint128((tokenAmount * taxParams.taxOverall) / FEE_FACTOR);
            latestTaxTokens.treasuryTokenReserve += uint80(
                (valueTax * taxParams.taxOverall) / taxParams.taxOverall / 1e9
            );
            taxTokenAccount = latestTaxTokens;
            super._transfer(dispatch, address(this), valueTax);
        }

        return valueTax;
    }
    
    function upholdLimits(
        address dispatch,
        address receiverEntity,
        uint256 tokenAmount
    ) internal {
        if (tradingLimitsEnabled) {
            bool exemptRecipientLimits = isLimitExempt[receiverEntity];
            uint256 recipientFunds = balanceOf(receiverEntity);
            TxLimits memory limitsTransaction = txBoundaries;
            // buy
            if (ammPairs[dispatch] && !exemptRecipientLimits) {
                require(tokenAmount <= limitsTransaction.maxTx, "Max Txn");
                require(
                    tokenAmount + recipientFunds <= limitsTransaction.walletLimit,
                    "Max Wallet"
                );
            }
            // sell
            else if (ammPairs[receiverEntity] && !isLimitExempt[dispatch]) {
                require(tokenAmount <= limitsTransaction.maxTx, "Max Txn");
            } else if (!exemptRecipientLimits) {
                require(
                    tokenAmount + recipientFunds <= limitsTransaction.walletLimit,
                    "Max Wallet"
                );
            }

            if (transferDelayMode) {
                if (receiverEntity != address(dexRouterExchange) && receiverEntity != address(lpPair)) {
                    require(
                        transferTimeBlock[tx.origin] < block.number,
                        "Transfer Delay"
                    );
                    require(
                        tx.origin == receiverEntity,
                        "no buying to external wallets yet"
                    );
                }
            }
        }

        if (mevShield) {
            if (ammPairs[receiverEntity]) {
                require(
                    transferTimeBlock[dispatch] < block.number,
                    "Anti MEV"
                );
            } else {
                transferTimeBlock[receiverEntity] = block.number;
                transferTimeBlock[tx.origin] = block.number;
            }
        }
    }
    
    function disableTransferDelay() external onlyOwner {
        require(transferDelayMode, "Already disabled!");
        transferDelayMode = false;
    }
    
    function exchangeTokensTax() private {
        uint256 balanceInContract = balanceOf(address(this));
        TaxTokenInfo memory tokenTaxCurrent = taxTokenAccount;
        uint256 totalTokensSwap = tokenTaxCurrent.treasuryTokenReserve;

        if (balanceInContract == 0 || totalTokensSwap == 0) {
            return;
        }

        if (balanceInContract > swapThresholdLimit * 20) {
            balanceInContract = swapThresholdLimit * 20;
        }

        if (balanceInContract > 0) {
            swapTokensForETH(balanceInContract);

            uint256 balanceEth = address(this).balance;

            bool successStatus;

            balanceEth = address(this).balance;

            if (balanceEth > 0) {
                (successStatus, ) = centralTreasury.call{value: balanceEth}("");
            }
        }

        tokenTaxCurrent.treasuryTokenReserve = 0;
        taxTokenAccount = tokenTaxCurrent;
    }
    
    function maxTransactionUpdate(uint128 maxTokensNew) external onlyOwner {
        require(
            maxTokensNew >= ((totalSupply() * 1) / 1000) / (10**decimals()),
            "Too low"
        );
        txBoundaries.maxTx = uint128(maxTokensNew * (10**decimals()));
        emit TransactionUpdateMax(txBoundaries.maxTx);
    }
    receive() external payable {}
    function limitExemptStatusSet(address accountInfo, bool statusExempt)
        external
        onlyOwner
    {
        require(accountInfo != address(0), "Zero Address");
        if (!statusExempt) {
            require(accountInfo != lpPair, "Cannot remove pair");
        }
        isLimitExempt[accountInfo] = statusExempt;
        emit LimitExemptUpdate(accountInfo, statusExempt);
    }
    
    function modifySellTaxSettings(uint64 treasuryTax) external onlyOwner {
        TaxParameters memory taxConfig;
        taxConfig.taxOverall = treasuryTax;
        emit TaxSellUpdated(taxConfig.taxOverall);
        sellTaxParams = taxConfig;
    }
    }
