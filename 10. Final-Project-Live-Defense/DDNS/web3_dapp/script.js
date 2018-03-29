window.onload = function () {
    var el = document.getElementById("message");
    if (typeof web3 === 'undefined') {
        el.innerHTML = "Error! Are you sure that you are using metamask?";
    } else {
        el.innerHTML = "Welcome to our DDNS DAPP!";
        init();
    }
}

var contractInstance;

// ENTER ABI HERE:
var abi = [
    {
        "constant": true,
        "inputs": [
            {
                "name": "",
                "type": "address"
            },
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "receipts",
        "outputs": [
            {
                "name": "amountPaidWei",
                "type": "uint256"
            },
            {
                "name": "timestamp",
                "type": "uint256"
            },
            {
                "name": "expires",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "contractOwner",
        "outputs": [
            {
                "name": "",
                "type": "address"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "newOwner",
                "type": "address"
            }
        ],
        "name": "transferOwnership",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "payable": true,
        "stateMutability": "payable",
        "type": "fallback"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "name": "by",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "domain",
                "type": "bytes"
            }
        ],
        "name": "LogDomainRegistered",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "name": "from",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "to",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "domain",
                "type": "bytes"
            }
        ],
        "name": "LogDomainTransfered",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "name": "oldIp",
                "type": "bytes4"
            },
            {
                "indexed": true,
                "name": "newIp",
                "type": "bytes4"
            },
            {
                "indexed": false,
                "name": "domain",
                "type": "bytes"
            }
        ],
        "name": "LogDomainChangeIp",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": false,
                "name": "tokensAmmount",
                "type": "uint256"
            },
            {
                "indexed": false,
                "name": "date",
                "type": "uint256"
            }
        ],
        "name": "LogContractTokensWithdrawn",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": false,
                "name": "by",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "tokensTransRecieved",
                "type": "uint256"
            }
        ],
        "name": "LogFallbackCalled",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "name": "previousOwner",
                "type": "address"
            },
            {
                "indexed": true,
                "name": "newOwner",
                "type": "address"
            }
        ],
        "name": "OwnershipTransferred",
        "type": "event"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_domain",
                "type": "bytes"
            },
            {
                "name": "_ip",
                "type": "bytes4"
            }
        ],
        "name": "register",
        "outputs": [],
        "payable": true,
        "stateMutability": "payable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_domain",
                "type": "bytes"
            },
            {
                "name": "_newIp",
                "type": "bytes4"
            }
        ],
        "name": "edit",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_domain",
                "type": "bytes"
            },
            {
                "name": "_newOwner",
                "type": "address"
            }
        ],
        "name": "transferDomain",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_domain",
                "type": "bytes"
            }
        ],
        "name": "getIP",
        "outputs": [
            {
                "name": "",
                "type": "bytes4"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "getContractOwner",
        "outputs": [
            {
                "name": "",
                "type": "address"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_domain",
                "type": "bytes"
            }
        ],
        "name": "getDomainOwner",
        "outputs": [
            {
                "name": "",
                "type": "address"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [],
        "name": "withdraw",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_domain",
                "type": "bytes"
            }
        ],
        "name": "getPrice",
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "pure",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_domain",
                "type": "bytes"
            }
        ],
        "name": "getDomainStartsDate",
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_domain",
                "type": "bytes"
            }
        ],
        "name": "getDomainExpirationDate",
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    }
];

// ENTER ADDRESS HERE
var address = "0xf25186b5081ff5ce73482ad761db0eb0d25abfbf";

var acc;

function init() {
    var Contract = web3.eth.contract(abi);
    contractInstance = Contract.at(address);
    getCurrentAccount();
}

function registerDomain() {
    getCurrentAccount();

    var domainName = document.getElementById("input-domain").value.toString();
    var domainIp = document.getElementById("input-ip").value.toString();
    var price = web3.toWei(1, "ether");
    if (domainName.length > 0 && domainName.length <= 5) {
        price = web3.toWei(5, "ether");
    } else if (domainName.length > 5 && domainName.length <= 10) {
        price = web3.toWei(2, "ether");
    } else if (domainName.length > 10) {
        price = web3.toWei(1, "ether");
    } else {
        throw Error("Something went wrong");
    }
    contractInstance.register(domainName, domainIp, { "from": acc, "value": price }, function (err, res) {
        if (!err) {
            displayMessage("Registration/Extension domain: " + domainName + " successful! ");
        } else {
            displayMessage("Something went wrong. Domain might be already taken");
            console.log(err);
        }
    });
}

function getIP() {

    var domainName = document.getElementById("input-ip-get").value.toString();

    contractInstance.getIP.call(domainName, { "from": acc }, function (err, res) {
        if (!err) {
            if (res != '0x00000000') {
                displayMessage("The domain IP is: " + res);
            } else {
                displayMessage("There is no such domain registered");
            }
        } else {
            displayMessage("Something went wrong.");
            console.log(err);
        }
    });
}

function transferDomain() {
    var domainName = document.getElementById("input-transfer-domain").value.toString();
    var newOwner = document.getElementById("input-transfer-owner").value.toString();

    contractInstance.transferDomain(domainName, newOwner, { "from": acc }, function (err, res) {
        if (!err) {
            displayMessage("Domain " + domainName + " transfered succesfully to: " + newOwner);
        } else {
            displayMessage("Something went wrong.");
            console.log(err);
        }
    });
}

function getPrice() {
    var domainName = document.getElementById("input-price-domain").value.toString();
    console.log(domainName)
    contractInstance.getPrice.call(domainName, { "from": acc }, function (err, res) {
        if (!err) {
            displayMessage("Price for domain " + domainName + " is: " + web3.fromWei(res) + " ETH");
        } else {
            displayMessage("Something went wrong.");
            console.log(err);
        }
    });
}

function getCurrentAccount() {
    acc = web3.eth.accounts[0];
}

function displayMessage(_message) {
    document.querySelector('#demo-snackbar-example').MaterialSnackbar.showSnackbar({
        message: _message,
        timeout: 5000,
    });
}
