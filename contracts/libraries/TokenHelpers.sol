// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TokenHelpers
 * @dev Stateless helper library for common token validations.
 *
 * Why this matters:
 * - Libraries reduce duplication across V1 / V2
 * - No storage = no upgrade risk
 */

library TokenHelpers {
    error ZeroAddress();
    error ZeroAmount();
    error InsufficientBalance(uint256 balance, uint256 required);

    function validateAddress(address account) internal pure {
        if (account == address(0)) {
            revert ZeroAddress();
        }
    }

    function validateAmount(uint256 amount) internal pure {
        if (amount == 0) {
            revert ZeroAmount();
        }
    }

    function validateBalance(
        uint256 balance,
        uint256 required
    ) internal pure {
        if (balance < required) {
            revert InsufficientBalance(balance, required);
        }
    }
}