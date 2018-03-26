var DDNSRegisterer = artifacts.require("./DDNSRegisterer.sol");
var DDNS = artifacts.require("./DDNS.sol");

module.exports = function(deployer) {
    deployer.deploy(DDNSRegisterer);
    deployer.link(DDNSRegisterer, DDNS);
    deployer.deploy(DDNS);
};
