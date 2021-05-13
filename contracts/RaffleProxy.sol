pragma solidity =0.4.25;

import "./OwnedUpgradeabilityProxy.sol";

contract RaffleProxy is OwnedUpgradeabilityProxy {
    constructor() public OwnedUpgradeabilityProxy() {}
}
