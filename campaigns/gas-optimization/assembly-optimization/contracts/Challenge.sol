// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// abstract contract Challenge {

//     /**
//      * @notice Returns a copy of the given array in a gas efficient way.
//      * @dev This contract will be called internally.
//      * @param array The array to copy.
//      * @return copy The copied array.
//      */
//     function copyArray(bytes memory array) 
//         internal 
//         pure 
//         returns (bytes memory copy) 
//     {
//         uint256 value = array.length;
//         copy = new bytes(value);
//         for (uint256 i = 0; i < value;) {
//             copy[i] = array[i];

//             unchecked {
//                 ++i;
//             }
//         }

//     }
// }

abstract contract Challenge {
    /**
     * @notice Returns a copy of the given array in a gas efficient way.
     * @dev This contract will be called internally.
     * @param array The array to copy.
     * @return copy The copied array.
     */
    function copyArray(bytes memory array)
        internal
        pure
        returns (bytes memory copy)
    {
        assembly {
            // Get the length of the input array
            let len := mload(array)
            
            // Allocate memory for the output array
            // Add 32 bytes for the length field
            copy := mload(0x40)
            mstore(copy, len)
            
            // Skip length field
            let dataOffset := add(array, 32)
            let copyOffset := add(copy, 32)
            
            // Copy the contents of the input array to the output array
            for {
                let i := 0
            } lt(i, len) {
                i := add(i, 32)
            } {
                  // Load 32 bytes from the input array
                let elem := mload(add(dataOffset, i))
                
                // Store 32 bytes to the output array
                mstore(add(copyOffset, i), elem)
            }
            
            // Update the free memory pointer
            mstore(0x40, add(copy, add(32, len)))
        }
    }
}

