// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import {PriceOracle, CToken} from "../../PriceOracle.sol";
import {CErc20} from "../../CErc20.sol";
import {IOffchainFundPriceOracle} from "./interfaces/IOffchainFundPriceOracle.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract OffchainFundPriceOracleRouter is PriceOracle, Ownable {
    using Math for uint256;

    mapping(CToken => address) public oracles;
    
    constructor() Ownable(msg.sender) {}

    function getUnderlyingPrice(CToken cToken) public override view returns (uint) {
        if (oracles[cToken] == address(0)) {
            return 0;
        }
        uint256 answer = IOffchainFundPriceOracle(oracles[cToken]).currentPrice();
        uint256 scale = 10 ** (36 - IERC20Metadata(CErc20(address(cToken)).underlying()).decimals() - 8);
        return uint256(answer) * scale;
    }

    function setOracle(CToken cToken, address oracle) public onlyOwner {
        oracles[cToken] = oracle;
    }

    function getOracle(CToken cToken) public view returns (address) {
        return oracles[cToken];
    }
}
