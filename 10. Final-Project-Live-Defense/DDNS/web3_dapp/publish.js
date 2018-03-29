var Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:9545"));

var acc = web3.eth.accounts[0];

var abi = [];

var bytecode = "";

var Contract = web3.eth.contract(abi);

var publishData = {
    "from": acc,
    "data": bytecode,
    "gas": 4712388
}

Contract.new(publishData, function(err, contractInstance) {
    if (!err) {
        if (contractInstance.address) {
            console.log("New contract address is :", contractInstance.address);
        }
    } else {
        console.error(err);
    }
});
