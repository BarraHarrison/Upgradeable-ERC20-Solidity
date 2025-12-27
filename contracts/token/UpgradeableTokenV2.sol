// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./UpgradeableTokenV1.sol";

/**
 * @title UpgradeableTokenV2
 * @dev Adds a capped total supply to the token.
 *
 * Upgrade safety rules followed:
 * - V1 storage untouched
 * - New state appended
 * - New initializer uses reinitializer(2)
 */

contract UpgradeableTokenV2 is UpgradeableTokenV1 {
    uint256 private _cap;

    /// @custom:oz-upgrades-validate-as-initializer
    /// @custom:oz-upgrades-unsafe-allow-parent-initializers
    function initializeV2(uint256 cap_) external reinitializer(2) {
        require(cap_ > 0, "Cap must be > 0");
        _cap = cap_;
    }


    function cap() external view returns (uint256) {
        return _cap;
    }

    /**
     * @dev Enforce cap on minting.
     */
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override {
        // Minting case
        if (from == address(0)) {
            if (totalSupply() + value > _cap) {
                revert("ERC20: cap exceeded");
            }
        }

        super._update(from, to, value);
    }

    function version() external pure override returns (string memory) {
        return "V2";
    }
}