// SPDX-License-Identifier: MIT

pragma solidity ^0.6.7;

interface IInterstellarEncoder {
    enum ObjectClass {
        NaN,
        LAND,
        APOSTLE
    }
    function getObjectClass(uint256 _tokenId) external view returns (uint8);
}
