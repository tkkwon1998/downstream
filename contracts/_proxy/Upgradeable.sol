// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// import {ProxyStorageLib, ProxyStorage} from "../proxy/storages/ProxyStorage.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

/**
 * @title Upgradeable
 * @dev This contract provides support for upgradeability.
 */
contract Upgradeable is UUPSUpgradeable {

    error Unauthorized();

    function _authorizeUpgrade(address) internal view override {
        if (ERC1967Utils.getAdmin() != msg.sender) {
            revert Unauthorized();
        }
    }

    function implementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }

    function setAdmin(address newAdmin) external {
        if (ERC1967Utils.getAdmin() != msg.sender) {
            revert Unauthorized();
        }
        ERC1967Utils.changeAdmin(newAdmin);
    }

    function getAdmin() external view returns (address) {
        return ERC1967Utils.getAdmin();
    }
}