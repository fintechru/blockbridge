// SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.8.0;

// import "./ValidatorList.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ValidatorList is Ownable {
    mapping(address => bool) validators;
    address[] validatorIndex;

    modifier onlyValidator() {
        require(validators[msg.sender], "ERROR: msg.sender isn't validator");
        _;
    }

    function _addValidator(address validator) internal onlyOwner {
        validators[validator] = true;
        validatorIndex.push(validator);
    }

    function removeValidator(address validator) internal onlyOwner {
        // uint256 i = _find(validator);
        // removeByIndex(i);
        validators[validator] = false;
    }

    // TODO
    // function removeByIndex(uint256 i) public onlyOwner {
    //     while (i < validatorIndex.length - 1) {
    //         validators[i] = validators[i + 1];
    //         i++;
    //     }
    //     validators.pop();
    // }

    // function _find(address validator) internal view returns (uint256) {
    //     // первый добавленный валидатор будет под номером 0

    //     uint256 i = 0;
    //     while (validators[i] != validator) {
    //         i++;
    //     }
    //     return i;
    // }

    function validatorNum() public view returns (uint256) {
        return validatorIndex.length;
    }

}
