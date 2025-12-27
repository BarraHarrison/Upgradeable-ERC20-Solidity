# Upgradeable ERC-20 Token (UUPS Pattern)

This project is a **protocol-grade upgradeable ERC-20 token** built with **Solidity, Hardhat, and OpenZeppelin**. It demonstrates how real-world Ethereum protocols design, deploy, and safely upgrade smart contracts **without redeploying the token or losing on-chain state**.

The focus of this repository is on **correct upgrade architecture, storage safety, and validator-aware upgrades**.

---

## 🎯 Project Goals

The primary goals of this project were to:

* Implement a **UUPS (Universal Upgradeable Proxy Standard)** ERC-20 token
* Separate **proxy and implementation logic** correctly
* Demonstrate **safe upgrades across contract versions**
* Extend storage without breaking existing state
* Use **initializers and reinitializers correctly**
* Enforce **role-based upgrade control**
* Understand and responsibly handle **OpenZeppelin upgrade validators**

This project mirrors how **production protocols** manage upgrades, not how tutorials simplify them.

---

## 🧱 Architecture Overview

### UUPS Proxy Pattern

* A **single proxy contract** holds all user balances and state
* Implementation contracts contain logic only
* The proxy delegates calls to the current implementation
* Upgrades replace the implementation **without changing the proxy address**

### Proxy vs Implementation

* **Proxy address**: what users interact with
* **Implementation address**: logic contract that can be replaced
* Users never need to migrate balances or change addresses

---

## 🔐 Access Control & Upgrade Safety

* Uses **OpenZeppelin AccessControl**
* Only accounts with `UPGRADER_ROLE` can authorize upgrades
* `_authorizeUpgrade()` enforces upgrade permissions
* Prevents unauthorized or accidental upgrades

---

## 🧠 Versioning & Upgrades

### Version 1 – `UpgradeableTokenV1`

* Standard ERC-20 functionality
* Pausable transfers
* Role-based minting and burning
* Initializer replaces constructor
* Parent initializers executed exactly once

### Version 2 – `UpgradeableTokenV2`

* Adds a **total supply cap**
* Introduces **new storage safely**
* Uses `reinitializer(2)` for upgrade-specific initialization
* Extends logic via the ERC-20 v5 `_update` hook
* Preserves all balances, supply, and roles from V1

---

## 🧬 Storage Safety

This project strictly follows upgrade-safe storage rules:

* No storage reordering
* No storage deletion
* New state variables appended only
* Explicit storage gaps reserved for future upgrades

As a result:

* Existing balances remain intact
* Total supply remains unchanged
* Roles persist across upgrades

---

## 🛠 OpenZeppelin Validator Awareness

The upgrade process deliberately engages with OpenZeppelin’s static validator:

* Reinitializers are explicitly documented
* Parent initializers are intentionally *not* re-called
* `unsafeAllow` flags are used **surgically**, not blindly
* Validator warnings are understood, reviewed, and accepted with intent

This reflects how real protocols handle **validator limitations vs runtime reality**.

---

## ✅ What This Project Demonstrates

By completing this project, I have demonstrated:

* Correct use of the **UUPS proxy pattern**
* Proper separation of **proxy vs implementation**
* Safe **storage extension across versions**
* Correct use of **initializer vs reinitializer**
* Controlled upgrades via `_authorizeUpgrade`
* Understanding of **OpenZeppelin validator rules**
* When and how to use `unsafeAllow` **responsibly**

This is **protocol-grade Solidity engineering**, not tutorial-level experimentation.

---

## 🚀 Tooling & Stack

* Solidity ^0.8.x
* Hardhat (v2)
* OpenZeppelin Contracts & Contracts-Upgradeable
* Ethers.js
* TypeScript
* Local Hardhat node for persistent upgrades

---

## 📌 Final Notes

This repository is intended as:

* A **learning milestone** in advanced Solidity
* A **portfolio-ready example** of upgradeable contract design
* A reference implementation for future protocol work

The patterns used here are the same ones employed by major Ethereum protocols in production.

---
