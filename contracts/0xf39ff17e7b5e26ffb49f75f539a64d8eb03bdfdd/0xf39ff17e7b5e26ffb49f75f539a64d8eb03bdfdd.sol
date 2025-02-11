/**
 *Submitted for verification at Etherscan.io on 2024-06-27
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma abicoder v2;

interface ICurveMetaRegister {

    function get_balances(address _pool) external view returns (uint256[8] memory);

    function get_underlying_balances(address _pool) external view returns (uint256[8] memory);

    function get_coins(address _pool) external view returns (address[8] memory);

    function get_underlying_coins(address _pool) external view returns (address[8] memory);

    function is_meta(address _pool) external view returns (bool);

    function get_n_coins(address _pool) external view returns (uint256);

    function get_registry_handlers_from_pool(address _pool) external view returns (address[10] memory);

}

interface ICurveMainBaseRegistry {
    function get_underlying_balances(address _pool) external view returns (uint256[8] memory);
    function get_underlying_coins(address _pool) external view returns (address[8] memory);
    function get_coins(address _pool) external view returns (address[8] memory);
}

interface ICurveV2Pool {

    function gamma() external view returns (uint256);

    function D() external view returns (uint256);

    function price_scale(uint256 k) external view returns (uint256);

    function fee_gamma() external view returns (uint256);

    function mid_fee() external view returns (uint256);

    function out_fee() external view returns (uint256);

}

interface ICurveNGPool {

    function offpeg_fee_multiplier() external view returns (uint256);

    function stored_rates() external view returns (uint256[] memory);

}

interface ICurveNG2Pool {

    function stored_rates() external view returns (uint256[2] memory);

}

interface ICurvePool {

    function A() external view returns (uint256);

    function fee() external view returns (uint256);

    function price_scale() external view returns (uint256);

    function get_virtual_price() external view returns (uint256);

}

interface ICurveMetaPool {

    function base_pool() external view returns (address);

}

interface IRai {

    function redemption_price_snap() external view returns (address);

    function snappedRedemptionPrice() external view returns (uint256);

}

interface AETH {

    function ratio() external view returns (uint256);

}

interface RETH {

    function getExchangeRate() external view returns (uint256);

}

interface ICurveSpecialPool {
    function coins(uint256 _index) external view returns (address);
}

contract QueryCurve {

    address public metaRegister;
    address public owner;

    constructor(address register) {
        metaRegister = register;
        owner = msg.sender;
    }

    function get_balances(
        address pool
    ) public view returns (uint256[8] memory balances) {

        bool is_meta = ICurveMetaRegister(metaRegister).is_meta(pool);
        address[10] memory handlers = ICurveMetaRegister(metaRegister).get_registry_handlers_from_pool(pool);

        if (!is_meta && 0x46a8a9CF4Fc8e99EC3A14558ACABC1D93A27de68 == handlers[0]) {
            // 兼容main registry里面的lending pool
            return ICurveMainBaseRegistry(0x90E00ACe148ca3b23Ac1bC8C240C2a7Dd9c2d7f5).get_underlying_balances(pool);
        } else {
            return ICurveMetaRegister(metaRegister).get_balances(pool);
        }

    }

    function get_tokens(
        address pool
    ) public view returns (address[8] memory tokens) {

        if (pool == 0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714) {
            return ICurveMetaRegister(metaRegister).get_coins(pool);
        }

        bool is_meta = ICurveMetaRegister(metaRegister).is_meta(pool);
        address[10] memory handlers = ICurveMetaRegister(metaRegister).get_registry_handlers_from_pool(pool);
        if (!is_meta && 0x46a8a9CF4Fc8e99EC3A14558ACABC1D93A27de68 == handlers[0]) {
            // 兼容main registry里面的lending pool
            return ICurveMainBaseRegistry(0x90E00ACe148ca3b23Ac1bC8C240C2a7Dd9c2d7f5).get_underlying_coins(pool);
        } else {
            return ICurveMetaRegister(metaRegister).get_coins(pool);
        }

    }

    function get_coins(
        address pool
    ) public view returns (address[8] memory tokens) {
        return ICurveMetaRegister(metaRegister).get_coins(pool);
    }

    function get_params(
        address pool
    ) public view returns (int24 name, uint256 A, uint256 fee, uint256 D, uint256 gamma, uint256 price,
        uint256 fee_gamma, uint256 mid_fee, uint256 out_fee, uint256 liquidity, uint256 gas_fee, uint256[] memory price_scale) {
        //params[0] 1-v1  2-v2  3-NG
        name = 1;
        gamma = 0;
        D = 0;
        price = 0;
        fee_gamma = 0;
        mid_fee = 0;
        out_fee = 0;
        liquidity = 0;
        gas_fee = 0;
        uint256 n = ICurveMetaRegister(metaRegister).get_n_coins(pool);
        price_scale = new uint256[](n - 1);
        try ICurveV2Pool(pool).gamma() returns (uint256 result0) {
            gamma = result0;
            name = 2;
            D = ICurveV2Pool(pool).D();
            if (n > 2) {
                for (uint256 i = 0; i < n - 1; i ++) {
                    price_scale[i] = ICurveV2Pool(pool).price_scale(i);
                }
            } else {
                price_scale[0] = ICurvePool(pool).price_scale();
            }
            fee_gamma = ICurveV2Pool(pool).fee_gamma();
            mid_fee = ICurveV2Pool(pool).mid_fee();
            out_fee = ICurveV2Pool(pool).out_fee();
        } catch {
            price = ICurvePool(pool).get_virtual_price();
            try ICurveNGPool(pool).offpeg_fee_multiplier() returns (uint256 result1) {
                gas_fee = result1;
                name = 3;
                price_scale = new uint256[](n);
                if (pool == 0xDeBF20617708857ebe4F679508E7b7863a8A8EeE) {
                    price_scale[0] = 10 ** 18;
                    price_scale[1] = 10 ** 18;
                    price_scale[2] = 10 ** 18;
                } else if (pool == 0xEB16Ae0052ed37f479f7fe63849198Df1765a733) {
                    price_scale[0] = 10 ** 18;
                    price_scale[1] = 10 ** 18;
                } else {
                    price_scale = ICurveNGPool(pool).stored_rates();
                }
            } catch {
                price_scale = new uint256[](n);
                if (pool == 0x618788357D0EBd8A37e763ADab3bc575D54c2C7d) {
                    address snap = IRai(pool).redemption_price_snap();
                    liquidity = IRai(snap).snappedRedemptionPrice();
                    price_scale[0] = liquidity / 10 ** 9;
                    price_scale[1] = ICurvePool(ICurveMetaPool(pool).base_pool()).get_virtual_price();
                } else if (
                    pool == 0xBfAb6FA95E0091ed66058ad493189D2cB29385E6 ||
                    pool == 0x21E27a5E5513D6e65C4f830167390997aA84843a ||
                    pool == 0x59Ab5a5b5d617E478a2479B0cAD80DA7e2831492 ||
                    pool == 0xfEF79304C80A694dFd9e603D624567D470e1a0e7 ||
                    pool == 0x1539c2461d7432cc114b0903f1824079BfCA2C92
                ) {
                    uint256[2] memory price_scale0 = ICurveNG2Pool(pool).stored_rates();
                    price_scale[0] = price_scale0[0];
                    price_scale[1] = price_scale0[1];
                } else if (pool == 0xA96A65c051bF88B4095Ee1f2451C2A9d43F53Ae2) {
                    price_scale[0] = 10 ** 18;
                    price_scale[1] = 10 ** 36 / AETH(ICurveSpecialPool(pool).coins(1)).ratio();
                } else if (pool == 0xF9440930043eb3997fc70e1339dBb11F341de7A8) {
                    price_scale[0] = 10 ** 18;
                    price_scale[1] = RETH(ICurveSpecialPool(pool).coins(1)).getExchangeRate();
                }
            }
        }
        A = ICurvePool(pool).A();
        fee = ICurvePool(pool).fee();

    }

    function setRegister(address newRegister) public {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        metaRegister = newRegister;
    }

}
