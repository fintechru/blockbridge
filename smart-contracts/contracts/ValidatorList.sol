// SPDX-License-Identifier: UNLICENSE

pragma solidity ^0.8.0;

import "./ValidatorList.sol";

contract ValidatorList {
    address[] private validators;

    modifier onlyValidator() {
        require(find(msg.sender) != 0);
        _;
    }

    function addValidator(address validator) public {
        validators.push(validator);
    }

    function removeValidator(address validator) public {
        uint256 i = find(validator);
        removeByIndex(i);
    }

    function removeByIndex(uint256 i) public {
        while (i < validators.length - 1) {
            validators[i] = validators[i + 1];
            i++;
        }
        validators.pop();
    }

    function find(address validator) public view returns (uint256) {
        uint256 i = 0;
        while (validators[i] != validator) {
            i++;
        }
        return i;
    }

    function validatorNum() public view returns (uint256) {
        return validators.length;
    }
}
