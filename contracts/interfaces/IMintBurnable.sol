// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IMintBurnable
 * @dev Minimal interface for a token that supports minting and burning.
 *
 * Why this matters for upgradeable contracts:
 * - It separates "what the contract does" from "how it's implemented"
 * - V2 can change internal logic while keeping this interface stable
 * - Frontends/tests can depend on this interface rather than concrete versions
 */
interface IMintBurnable {
    error ZeroAddress();
    error ZeroAmount();

    event Mint(address indexed to, uint256 amount, address indexed operator);
    event Burn(address indexed from, uint256 amount, address indexed operator);

    function mint(address to, uint256 amount) external;

    function burn(address from, uint256 amount) external;

    function burn(uint256 amount) external;
}
