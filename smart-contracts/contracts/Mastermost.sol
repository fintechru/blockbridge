// SPDX-License-Identifier: UNLICENSE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ValidatorList.sol";

contract Mastermost is ValidatorList {
    uint256 public totalSupply;

    enum Status {
        created,
        done,
        canceled
    }

    struct Deal {
        address[] confirmations;
        uint256 tokenNum;
        bytes32 networkId;
        address sender;
        address recipient;
        Status status;
        // mapping(address => Status) status;
    }

    mapping(bytes32 => Deal) validatorConfirmations;
    mapping(bytes32 => address) deals;
    mapping(address => uint256) balance;

    event SimpleDealInited(address who, bytes32 dealHash);
    event DetailedDealInited(
        bytes32 networkId,
        address recipient,
        address sender,
        uint256 tokenNum
    );

    event SimpleDealConfirmed(bytes32 dealHash);
    event DetailedDealConfirmed(
        bytes32 networkId,
        address recipient,
        address sender,
        uint256 tokenNum
    );
    event DealNotConfirmed(bytes32 dealHash);

    event DealCanceled(bytes32 dealHash);

    constructor() {
        totalSupply = 1000;
    }

    // Создать сделку указав только хеш значимых данных - hash(сумма перевода, сеть назначения, адрес получателя)
    function initDealByHash(bytes32 dealHash) public {
        // TODO: проверка адреса инициатора
        // TODO: проверка хеша на валидность
        deals[dealHash] = msg.sender;
        emit SimpleDealInited(msg.sender, dealHash);
    }

    // Создать сделку с данными
    function initDealByValue(
        uint256 _tokenNum,
        bytes32 _networkId,
        address _recipient
    ) public {
        bytes32 dealHash = keccak256(
            abi.encodePacked(_tokenNum, _networkId, _recipient)
        );

        address[] memory emptyAddressList;

        balance[msg.sender] -= _tokenNum;

        validatorConfirmations[dealHash] = Deal({
            confirmations: emptyAddressList,
            tokenNum: _tokenNum,
            networkId: _networkId,
            sender: msg.sender,
            recipient: _recipient,
            status: Status.created
        });

        deals[dealHash] = msg.sender;

        emit DetailedDealInited(_networkId, _recipient, msg.sender, _tokenNum);
    }

    // Подтвердить сделку валидатором
    function confirmDeal(bytes32 dealHash) public onlyValidator {
        // проверка статуса сделки
        Deal storage deal = validatorConfirmations[dealHash];

        uint256 valNum = validatorNum();
        uint256 confirmations = deal.confirmations.length;

        if (valNum == confirmations + 1) {
            deal.confirmations.push(msg.sender);
            balance[deal.recipient] += deal.tokenNum;
            deal.status = Status.done;
            emit DetailedDealConfirmed(
                deal.networkId,
                deal.recipient,
                deal.sender,
                deal.tokenNum
            );
        } else {
            deal.confirmations.push(msg.sender);
        }
    }

    // проверить сделку по ID
    function checkDeal(bytes32 dealHash) public returns (bool) {
        Deal memory deal = validatorConfirmations[dealHash];
        uint256 valNum = validatorNum();
        uint256 confirmations = deal.confirmations.length;

        if (valNum == confirmations) {
            emit SimpleDealConfirmed(dealHash);
            return true;
        }

        emit DealNotConfirmed(dealHash);
        return false;
    }

    function cancelDeal(bytes32 dealHash) public returns (bool) {
        // прошло время финализации сделки
        Deal storage deal = validatorConfirmations[dealHash];
        uint256 valNum = validatorNum();

        if (deal.confirmations.length < valNum) {
            balance[deal.sender] += deal.tokenNum;
            deal.status = Status.canceled;
            emit DealCanceled(dealHash);
            return true;
        }

        return false;
    }
}
