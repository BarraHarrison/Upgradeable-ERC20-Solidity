// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IMintBurnable} from "../interfaces/IMintBurnable.sol";
import {TokenHelpers} from "../libraries/TokenHelpers.sol";

/**
 * @title UpgradeableTokenV1
 * @dev Upgradeable ERC-20 (UUPS) with role-based mint/burn, pause, and upgrade authorization.
 *
 * Key upgradeable rules demonstrated:
 * - No constructor logic (use initialize)
 * - Storage layout must remain compatible across upgrades
 * - Upgrades are authorized via _authorizeUpgrade()
 */

contract UpgradeableTokenV1 is
    Initializable,
    ERC20Upgradeable,
    AccessControlUpgradeable,
    PausableUpgradeable,
    UUPSUpgradeable,
    IMintBurnable
{
    using TokenHelpers for address;
    using TokenHelpers for uint256;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    /**
     * @notice Initializes the proxy instance.
     * @dev This replaces the constructor for upgradeable contracts.
     */

    function initialize(
        string calldata name_,
        string calldata symbol_,
        address admin
    ) external initializer {
        admin.validateAddress();

        __ERC20_init(name_, symbol_);
        __AccessControl_init();
        __Pausable_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(MINTER_ROLE, admin);
        _grantRole(BURNER_ROLE, admin);
        _grantRole(PAUSER_ROLE, admin);
        _grantRole(UPGRADER_ROLE, admin);
    }


    function mint(address to, uint256 amount) external override onlyRole(MINTER_ROLE) {
        to.validateAddress();
        amount.validateAmount();

        _mint(to, amount);
        emit Mint(to, amount, msg.sender);
    }

    
    function burn(address from, uint256 amount) external override onlyRole(BURNER_ROLE) {
        from.validateAddress();
        amount.validateAmount();

        _burn(from, amount);
        emit Burn(from, amount, msg.sender);
    }

    function burn(uint256 amount) external override {
        amount.validateAmount();

        _burn(msg.sender, amount);
        emit Burn(msg.sender, amount, msg.sender);
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _update(address from, address to, uint256 value)
        internal
        override
        virtual
        whenNotPaused
    {
        super._update(from, to, value);
    }


    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {
        // newImplementation is validated by OZ upgrade mechanisms.
        (newImplementation);
    }


    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @notice Human-readable contract version (useful in tests + upgrades).
     */

    function version() external pure virtual returns (string memory) {
        return "V1";
    }

    uint256[50] private __gap;
}