// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract MultiSigWallet {
    address[] public owners;
    uint public required;
    mapping(address => bool) public isOwner;
    uint public transactionCount;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint confirmations;
        mapping(address => bool) isConfirmed;
    }

    Transaction[] public transactions;

    event Submission(uint indexed transactionId);
    event Confirmation(address indexed sender, uint indexed transactionId);
    event Execution(uint indexed transactionId);
    event ExecutionFailure(uint indexed transactionId);
    event Deposited(address indexed sender, uint value);

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier transactionExists(uint transactionId) {
        require(transactionId < transactionCount, "Transaction does not exist");
        _;
    }

    modifier notExecuted(uint transactionId) {
        require(!transactions[transactionId].executed, "Transaction already executed");
        _;
    }

    modifier notConfirmed(uint transactionId) {
        require(!transactions[transactionId].isConfirmed[msg.sender], "Transaction already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid number of required confirmations");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }

    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        uint transactionId = transactionCount;
        transactions.push();
        Transaction storage txn = transactions[transactionId];
        txn.to = _to;
        txn.value = _value;
        txn.data = _data;
        txn.executed = false;
        txn.confirmations = 0;
        transactionCount += 1;

        emit Submission(transactionId);
    }

    function confirmTransaction(uint transactionId) public onlyOwner transactionExists(transactionId) notExecuted(transactionId) notConfirmed(transactionId) {
        Transaction storage txn = transactions[transactionId];
        txn.isConfirmed[msg.sender] = true;
        txn.confirmations += 1;

        emit Confirmation(msg.sender, transactionId);

        if (txn.confirmations >= required) {
            executeTransaction(transactionId);
        }
    }

    function executeTransaction(uint transactionId) public onlyOwner transactionExists(transactionId) notExecuted(transactionId) {
        Transaction storage txn = transactions[transactionId];
        require(txn.confirmations >= required, "Not enough confirmations");

        txn.executed = true;
        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        if (success) {
            emit Execution(transactionId);
        } else {
            emit ExecutionFailure(transactionId);
            txn.executed = false;
        }
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint) {
        return transactionCount;
    }

    function getTransaction(uint transactionId) public view returns (address to, uint value, bytes memory data, bool executed, uint confirmations) {
        Transaction storage txn = transactions[transactionId];
        return (txn.to, txn.value, txn.data, txn.executed, txn.confirmations);
    }

    function isConfirmed(uint transactionId, address owner) public view returns (bool) {
        return transactions[transactionId].isConfirmed[owner];
    }
}