pragma solidity 0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DDNS.sol";

contract TestDDNS {
    function testDomainPriceShort() public {
        DDNS instance = DDNS(DeployedAddresses.DDNS());
        
        uint256 price = instance.getPrice("12345");
        Assert.equal(price, 5000000000000000000, "Price not correct");
    }

    function testDomainPriceMedium() public {
        DDNS instance = DDNS(DeployedAddresses.DDNS());
        
        uint256 price = instance.getPrice("1234567");
        Assert.equal(price, 2000000000000000000, "Price not correct");
    }

    function testDomainPriceLong() public {
        DDNS instance = DDNS(DeployedAddresses.DDNS());
        
        uint256 price = instance.getPrice("1234567890123");
        Assert.equal(price, 1000000000000000000, "Price not correct");
    }

}