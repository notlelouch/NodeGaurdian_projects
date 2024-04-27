// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Mind {
    /// @notice This could be useful...
    address public immutable deploymentAddress;

    constructor() {
        deploymentAddress = address(this);
    }

    /// @notice Checks if the current call is a delegate call.
    /// @return isDelegate true if this is a delegate call, false otherwise.
    function isDelegateCall() public view returns (bool isDelegate) {
        isDelegate = (deploymentAddress != address(this));
        return isDelegate;
    }
}