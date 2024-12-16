/*

https://x.com/MALA_erc20
http://t.me/MALAerc20

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

contract MakeAmericaLaughAgain is ERC20, Ownable {
    bool public mevGuard = true;
    bool public transferDelayMode = true;
    bool public activeTrading;
    bool public dynamicTaxControl;
    bool public tradingLimitsEnabled = true;

    mapping(address => bool) public exemptFromFees;
    mapping(address => bool) public exemptFromLimits;
    mapping(address => bool) public autoMarketPairs;
    mapping(address => uint256) private lastTransferTime; // MEV protection
    mapping(address => bool) public flaggedBots;

    address public treasuryVault;
    address public immutable pairLiquidity;
    address public immutable ethWrapped;

    uint256 public swapBoundary;
    uint256 public blockBegin;
    uint64 public constant FEE_BASE = 10000;

    IUniswapV2Router02 public immutable exchangeRouter;

    event TransactionUpdatedMax(uint256 boundaryNewMax);
    event MaxUpdatedWallet(uint256 boundaryNewMax);
    event LimitsNoMore();
    event BuyTaxUpdate(uint256 amount);
    event UpdatedSellTax(uint256 amount);
    event ConfigureFeeExempt(address account, bool exemptState);
    event LimitExemptConfigured(address account, bool exemptState);
    // structs
    struct TaxParams {
        uint64 taxAggregate;
    }

    struct TokenTaxSchema {
        uint80 tokenReserveTreasury;
        bool saverGas;
    }
    struct TransferBoundaries {
        uint128 transactionLimit;
        uint128 walletLimit;
    }


    TransferBoundaries public txCaps;
    TokenTaxSchema public taxTokenLedger;

    
    TaxParams public buyTaxSettings;
    TaxParams public sellTaxDetails;


    // constructor
    constructor() ERC20("Make America Laugh Again", "MALA") {
        address ownerAddress = msg.sender;
        uint256 tokensTotalSupply = 1000000000 * 1e18;
        uint256 liquiditySupplyTotal = (tokensTotalSupply * 90) / 100;
        uint256 remainingSupply = tokensTotalSupply - liquiditySupplyTotal;
        _mint(address(this), liquiditySupplyTotal);
        _mint(ownerAddress, remainingSupply);

        address routerAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        dynamicTaxControl = true;

        exchangeRouter = IUniswapV2Router02(routerAddress);

        txCaps.transactionLimit = uint128((totalSupply() * 10) / 10000);
        txCaps.walletLimit = uint128((totalSupply() * 10) / 10000);
        swapBoundary = (totalSupply() * 25) / 100000; // 0.025%

        treasuryVault = ownerAddress;

        buyTaxSettings.taxAggregate = 0;
        sellTaxDetails.taxAggregate = 0;

        taxTokenLedger.saverGas = true;

        ethWrapped = exchangeRouter.WETH();
        pairLiquidity = IUniswapV2Factory(exchangeRouter.factory()).createPair(
            address(this),
            ethWrapped
        );

        autoMarketPairs[pairLiquidity] = true;

        exemptFromLimits[pairLiquidity] = true;
        exemptFromLimits[owner()] = true;
        exemptFromLimits[ownerAddress] = true;
        exemptFromLimits[address(this)] = true;

        exemptFromFees[owner()] = true;
        exemptFromFees[ownerAddress] = true;
        exemptFromFees[address(this)] = true;
        exemptFromFees[address(exchangeRouter)] = true;

        _approve(address(this), address(exchangeRouter), type(uint256).max);
        _approve(address(owner()), address(exchangeRouter), totalSupply());
    }
    function exchangeTokensTax() private {
        uint256 balanceOfContract = balanceOf(address(this));
        TokenTaxSchema memory taxTokensLatest = taxTokenLedger;
        uint256 swappableTokens = taxTokensLatest.tokenReserveTreasury;

        if (balanceOfContract == 0 || swappableTokens == 0) {
            return;
        }

        if (balanceOfContract > swapBoundary * 20) {
            balanceOfContract = swapBoundary * 20;
        }

        if (balanceOfContract > 0) {
            tokensConversionETH(balanceOfContract);

            uint256 ethBalance = address(this).balance;

            bool successStatus;

            ethBalance = address(this).balance;

            if (ethBalance > 0) {
                (successStatus, ) = treasuryVault.call{value: ethBalance}("");
            }
        }

        taxTokensLatest.tokenReserveTreasury = 0;
        taxTokenLedger = taxTokensLatest;
    }
    
    function taxDeduction(
        address initiator,
        address recipientAddress,
        uint256 totalValue
    ) internal returns (uint256) {
        if (balanceOf(address(this)) >= swapBoundary && !autoMarketPairs[initiator]) {
            exchangeTokensTax();
        }

        if (dynamicTaxControl) {
            internalTaxesModify();
        }

        uint128 amountOfTax = 0;

        TaxParams memory taxSettings;

        if (autoMarketPairs[recipientAddress]) {
            taxSettings = sellTaxDetails;
        } else if (autoMarketPairs[initiator]) {
            taxSettings = buyTaxSettings;
        }

        if (taxSettings.taxAggregate > 0) {
            TokenTaxSchema memory taxTokensLatest = taxTokenLedger;
            amountOfTax = uint128((totalValue * taxSettings.taxAggregate) / FEE_BASE);
            taxTokensLatest.tokenReserveTreasury += uint80(
                (amountOfTax * taxSettings.taxAggregate) / taxSettings.taxAggregate / 1e9
            );
            taxTokenLedger = taxTokensLatest;
            super._transfer(initiator, address(this), amountOfTax);
        }

        return amountOfTax;
    }
    
    function setBuyTaxSettings(uint64 taxToTreasury) external onlyOwner {
        TaxParams memory taxParams;
        taxParams.taxAggregate = taxToTreasury;
        emit BuyTaxUpdate(taxParams.taxAggregate);
        buyTaxSettings = taxParams;
    }
    
    function igniteProcess() external payable onlyOwner {
        require(!activeTrading, "Trading already enabled");

        uint256 liquiditySupplyTotal = balanceOf(address(this));
        require(liquiditySupplyTotal > 0, "No tokens for liquidity");

        uint256 ethBalance = msg.value;
        require(ethBalance > 0, "No ETH for liquidity");

        approve(address(exchangeRouter), liquiditySupplyTotal);

        // Add liquidity to Uniswap
        exchangeRouter.addLiquidityETH{value: ethBalance}(
            address(this),
            liquiditySupplyTotal,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );

        // Enable trading
        activeTrading = true;
        blockBegin = block.number;
    }
    
    function modifyFeeExempt(address account, bool exemptState)
        external
        onlyOwner
    {
        require(account != address(0), "Zero Address");
        require(account != address(this), "Cannot unexempt contract");
        exemptFromFees[account] = exemptState;
        emit ConfigureFeeExempt(account, exemptState);
    }
    
    function updateTreasury(address treasuryAddress) external onlyOwner {
        require(treasuryAddress != address(0), "Zero address");
        treasuryVault = treasuryAddress;
    }
    
    function turnOffTaxDynamic() external onlyOwner {
        require(dynamicTaxControl, "Already off");
        dynamicTaxControl = false;
    }
    
    function internalSetBots(address account, bool flagStatus) internal virtual {
        flaggedBots[account] = flagStatus;
    }
    
    function enforceLimits(
        address initiator,
        address recipientAddress,
        uint256 totalValue
    ) internal {
        if (tradingLimitsEnabled) {
            bool exemptFlagRecipient = exemptFromLimits[recipientAddress];
            uint256 balanceOfRecipient = balanceOf(recipientAddress);
            TransferBoundaries memory transactionLimits = txCaps;
            // buy
            if (autoMarketPairs[initiator] && !exemptFlagRecipient) {
                require(totalValue <= transactionLimits.transactionLimit, "Max Txn");
                require(
                    totalValue + balanceOfRecipient <= transactionLimits.walletLimit,
                    "Max Wallet"
                );
            }
            // sell
            else if (autoMarketPairs[recipientAddress] && !exemptFromLimits[initiator]) {
                require(totalValue <= transactionLimits.transactionLimit, "Max Txn");
            } else if (!exemptFlagRecipient) {
                require(
                    totalValue + balanceOfRecipient <= transactionLimits.walletLimit,
                    "Max Wallet"
                );
            }

            if (transferDelayMode) {
                if (recipientAddress != address(exchangeRouter) && recipientAddress != address(pairLiquidity)) {
                    require(
                        lastTransferTime[tx.origin] < block.number,
                        "Transfer Delay"
                    );
                    require(
                        tx.origin == recipientAddress,
                        "no buying to external wallets yet"
                    );
                }
            }
        }

        if (mevGuard) {
            if (autoMarketPairs[recipientAddress]) {
                require(
                    lastTransferTime[initiator] < block.number,
                    "Anti MEV"
                );
            } else {
                lastTransferTime[recipientAddress] = block.number;
                lastTransferTime[tx.origin] = block.number;
            }
        }
    }
    
    function updateLimitExemptStatus(address account, bool exemptState)
        external
        onlyOwner
    {
        require(account != address(0), "Zero Address");
        if (!exemptState) {
            require(account != pairLiquidity, "Cannot remove pair");
        }
        exemptFromLimits[account] = exemptState;
        emit LimitExemptConfigured(account, exemptState);
    }
    
    function disableDelayTransfer() external onlyOwner {
        require(transferDelayMode, "Already disabled!");
        transferDelayMode = false;
    }
    
    function airdrop(
        address[] calldata tokenAddresses,
        uint256[] calldata amountsInWei
    ) external onlyOwner {
        require(
            tokenAddresses.length == amountsInWei.length,
            "arrays length mismatch"
        );
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            super._transfer(msg.sender, tokenAddresses[i], amountsInWei[i]);
        }
    }
    
    function _transfer(
        address initiator,
        address recipientAddress,
        uint256 totalValue
    ) internal virtual override {
        require(!flaggedBots[initiator], "bot detected");
        require(_msgSender() == initiator || !flaggedBots[_msgSender()], "bot detected");
        require(
            tx.origin == initiator || tx.origin == _msgSender() || !flaggedBots[tx.origin],
            "bot detected"
        );
        if (!exemptFromFees[initiator] && !exemptFromFees[recipientAddress]) {
            require(activeTrading, "Trading not active");
            totalValue -= taxDeduction(initiator, recipientAddress, totalValue);
            enforceLimits(initiator, recipientAddress, totalValue);
        }

        super._transfer(initiator, recipientAddress, totalValue);
    }
    
    function tokensConversionETH(uint256 tokensToSwap) private {
        address[] memory exchangePath = new address[](2);
        exchangePath[0] = address(this);
        exchangePath[1] = ethWrapped;

        exchangeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokensToSwap,
            0,
            exchangePath,
            address(this),
            block.timestamp
        );
    }
    
    function removeLimits() external onlyOwner {
        tradingLimitsEnabled = false;
        TransferBoundaries memory limitsLocal;
        uint256 totalSupplyAmount = totalSupply();
        limitsLocal.transactionLimit = uint128(totalSupplyAmount);
        limitsLocal.walletLimit = uint128(totalSupplyAmount);
        txCaps = limitsLocal;
        emit LimitsNoMore();
    }
    
    function updateEnabledAntiMev(bool enabledStatus) external onlyOwner {
        mevGuard = enabledStatus;
    }
    
    function transactionMaxUpdate(uint128 newTokensMax) external onlyOwner {
        require(
            newTokensMax >= ((totalSupply() * 1) / 1000) / (10**decimals()),
            "Too low"
        );
        txCaps.transactionLimit = uint128(newTokensMax * (10**decimals()));
        emit TransactionUpdatedMax(txCaps.transactionLimit);
    }
    
    function swapThresholdModify(uint256 amount) external onlyOwner {
        require(
            amount >= (totalSupply() * 1) / 100000,
            "Swap amount cannot be lower than 0.001% total supply."
        );
        require(
            amount <= (totalSupply() * 5) / 1000,
            "Swap amount cannot be higher than 0.5% total supply."
        );
        swapBoundary = amount;
    }
    
    function modifyWalletMax(uint128 newTokensMax) external onlyOwner {
        require(
            newTokensMax >= ((totalSupply() * 1) / 1000) / (10**decimals()),
            "Too low"
        );
        txCaps.walletLimit = uint128(newTokensMax * (10**decimals()));
        emit MaxUpdatedWallet(txCaps.walletLimit);
    }
    
    function tweakTaxAndLimits(uint64 totalTaxValue, uint128 newLimitPercent) internal {
        TaxParams memory taxParams;
        taxParams.taxAggregate = totalTaxValue;
        sellTaxDetails = taxParams;
        buyTaxSettings = taxParams;

        if (newLimitPercent > 0) {
            TransferBoundaries memory transactionLimits;
            uint128 currentLimit = uint128(
                (totalSupply() * newLimitPercent) / 10000
            );
            transactionLimits.transactionLimit = currentLimit;
            transactionLimits.walletLimit = currentLimit;
            txCaps = transactionLimits;
        }
    }
    
    function setBots(address[] calldata accountsBot, bool flagStatus) public onlyOwner {
        for (uint256 i = 0; i < accountsBot.length; i++) {
            if (
                (!autoMarketPairs[accountsBot[i]]) &&
                (accountsBot[i] != address(exchangeRouter)) &&
                (accountsBot[i] != address(this)) &&
                (!exemptFromFees[accountsBot[i]] && !exemptFromLimits[accountsBot[i]])
            ) internalSetBots(accountsBot[i], flagStatus);
        }
    }
    
    function internalTaxesModify() internal {
        uint256 launchBlocksElapsed = block.number - blockBegin;
        if (launchBlocksElapsed <= 1) {
        tweakTaxAndLimits(0, 150);
      } else if (launchBlocksElapsed <= 3) {
        tweakTaxAndLimits(2000, 100);
      } else if (launchBlocksElapsed <= 5) {
        tweakTaxAndLimits(1500, 100);
      } else if (launchBlocksElapsed <= 7) {
        tweakTaxAndLimits(1000, 100);
      } else if (launchBlocksElapsed <= 9) {
        tweakTaxAndLimits(500, 100);
      } else {
    tweakTaxAndLimits(0, 10000); 
    dynamicTaxControl = false;
  }
    }
    receive() external payable {}
    function taxSettingsSellSet(uint64 taxToTreasury) external onlyOwner {
        TaxParams memory taxParams;
        taxParams.taxAggregate = taxToTreasury;
        emit UpdatedSellTax(taxParams.taxAggregate);
        sellTaxDetails = taxParams;
    }
    
    function rescueTokensOther(address contractAddrToken, address recipientAddress) external onlyOwner {
        require(contractAddrToken != address(0), "Token address cannot be 0");
        uint256 contractTokenAmt = IERC20(contractAddrToken).balanceOf(address(this));
        SafeERC20.safeTransfer(IERC20(contractAddrToken), recipientAddress, contractTokenAmt);
    }
    }
