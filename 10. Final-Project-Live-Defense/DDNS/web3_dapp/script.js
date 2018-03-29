window.onload = function() {
    if (typeof web3 === 'undefined') {
        displayMessage("Error! Are you sure that you are using metamask?");
    } else {
        displayMessage("Welcome to our DAPP!");
        init();
    }
}

var contractInstance;

var abi = [{
        "constant": false,
        "inputs": [{
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
        "constant": true,
        "inputs": [{
            "name": "_domain",
            "type": "bytes"
        }],
        "name": "getDomainExpirationDate",
        "outputs": [{
            "name": "",
            "type": "uint256"
        }],
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
        "inputs": [],
        "name": "getContractOwner",
        "outputs": [{
            "name": "",
            "type": "address"
        }],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [{
            "name": "_domain",
            "type": "bytes"
        }],
        "name": "getPrice",
        "outputs": [{
            "name": "",
            "type": "uint256"
        }],
        "payable": false,
        "stateMutability": "pure",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [{
            "name": "_domain",
            "type": "bytes"
        }],
        "name": "getDomainStartsDate",
        "outputs": [{
            "name": "",
            "type": "uint256"
        }],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [{
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
        "inputs": [{
                "name": "",
                "type": "address"
            },
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "receipts",
        "outputs": [{
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
        "inputs": [{
            "name": "_domain",
            "type": "bytes"
        }],
        "name": "getIP",
        "outputs": [{
            "name": "",
            "type": "bytes4"
        }],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "contractOwner",
        "outputs": [{
            "name": "",
            "type": "address"
        }],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [{
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
        "constant": true,
        "inputs": [{
            "name": "_domain",
            "type": "bytes"
        }],
        "name": "getDomainOwner",
        "outputs": [{
            "name": "",
            "type": "address"
        }],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [{
            "name": "newOwner",
            "type": "address"
        }],
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
        "inputs": [{
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
        "inputs": [{
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
        "inputs": [{
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
        "inputs": [{
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
        "inputs": [{
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
        "inputs": [{
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
    }
];

var address = "0x8cdaf0cd259887258bc13a92c0a6da92698644c0";
var acc;

function init() {
    var Contract = web3.eth.contract(abi);
    contractInstance = Contract.at(address);
    getCurrentAccount();
}

function getCurrentAccount() {
    acc = web3.eth.accounts[0];
}

function displayMessage(message) {
    var el = document.getElementById("message");
    el.innerHTML = message;
}

function getTextInput() {
    var el = document.getElementById("input");

    return el.value;
}

function onButtonPressed() {
    getCurrentAccount();

    // contractInstance.register("0x11223344556677889900112233", "0x1111", { "from": acc, "value": web3.toWei(5, "ether") }, function(err, res) {
    //     console.log(err);
    //     console.log('*******');
    //     console.log(res);
    //     console.log('========');
    // });

    // contractInstance.getPrice.call("1111111111", { from: acc }, function(err, res) {
    //     console.log(err);
    //     console.log('*******');
    //     console.log(res);
    //     console.log('========');
    // })

    console.log(contractInstance.address);
    console.log(acc);

    contractInstance.getContractOwner.call({ "from": acc }, function(err, res) {
        console.log(err);
        console.log('*******');
        console.log(res);
        console.log('========');
    })
}

function onSecondButtonPressed() {
    getCurrentAccount();

    //TODO
}
