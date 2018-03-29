var Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:9545"));

var acc = web3.eth.accounts[0]; //get the first account

//Code:
/*
contract Ownable {
    address public owner;
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    
    function Ownable() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
*/

//Store this contract's compiled bytecode and ABI
var abi = [{ "constant": true, "inputs": [], "name": "owner", "outputs": [{ "name": "", "type": "address" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [{ "name": "newOwner", "type": "address" }], "name": "transferOwnership", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [{ "indexed": true, "name": "previousOwner", "type": "address" }, { "indexed": true, "name": "newOwner", "type": "address" }], "name": "OwnershipTransferred", "type": "event" }]
var bytecode = "63878646f69091846000604051602001526040518363ffffffff167c01000000000000000000000000000000000000000000000000000000000281526004018083815260200180602001828103825283818151815260200191508051906020019080838360005b8381101561244b578082015181840152602081019050612430565b50505050905090810190601f1680156124785780820380516001836020036101000a031916815260200191505b50935050505060206040518083038186803b151561249557600080fd5b6102c65a03f415156124a657600080fd5b505050604051805190509050919050565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614151561251357600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff161415151561254f57600080fd5b8073ffffffffffffffffffffffffffffffffffffffff16600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a380600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b60a0604051908101604052806126236126ac565b815260200160007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19168152602001600073ffffffffffffffffffffffffffffffffffffffff16815260200160008152602001600081525090565b8154818355818115116126a7576003028160030283600052602060002091820191016126a691906126c0565b5b505050565b602060405190810160405280600081525090565b6126f491905b808211156126f05760008082016000905560018201600090556002820160009055506003016126c6565b5090565b905600a165627a7a7230582039dad53da697b87aebdc333a5d7388b1da9f5fb24cf5383797e56e04d216c4c00029"

//create the contract instance. We can use this instance to publish or connect to a published contract
var Contract = web3.eth.contract(abi);

//create a JS Object (key-value pairs), holding the data we need to publish our contract
var publishData = {
    "from": acc, //the account from which it will be published
    "data": bytecode,
    "gas": 4000000 //gas limit. This should be the same or lower than Ethereum's gas limit
}

//publish the contract, passing a callback that will be called twice. Once when the transaction is sent, and once when it is mined
//the first argument is the constructor argument
Contract.new(publishData, function(err, contractInstance) {
    if (!err) {
        if (contractInstance.address) { //if the contract has an address aka if the transaction is mined
            console.log("New contract address is :", contractInstance.address);
        }
    } else {
        console.error(err); //something went wrong
    }
});
