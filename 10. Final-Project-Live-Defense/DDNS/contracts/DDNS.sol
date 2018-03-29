pragma solidity 0.4.19;

import "./DDNSRegisterer.sol";
import "./DDNSInterface.sol";
import "./Ownable.sol";

contract DDNS is DDNSInterface, Ownable {
    using DDNSRegisterer for DDNSRegisterer.DomainsData;
    
    DDNSRegisterer.DomainsData domains;
    
    event LogDomainRegistered (address indexed by, bytes domain);
    event LogDomainTransfered (address indexed from, address to, bytes  domain);
    event LogDomainChangeIp (bytes4 indexed oldIp, bytes4 indexed newIp, bytes domain);
    event LogContractTokensWithdrawn (uint tokensAmmount, uint date);
    event LogFallbackCalled (address by, uint tokensTransRecieved);
    
    modifier AvailableToBuy (bytes _domain) {
        DDNSRegisterer.Domain memory domainData = domains.domainsInfo[_domain];
        if(msg.sender != domainData.owner){
            require(domainData.expires < now);
            assert(domainData.starts < now);
        }
        _;                     
    }
    
    modifier PaymentHandler (bytes _domain) {
        uint cost = getPrice(_domain);
        uint difference = 0;
        if(msg.value == cost){
            _;
        } else if( msg.value < cost){
            revert();   
        } else {
            difference = msg.value - cost;
            assert(difference > 0);
            msg.sender.transfer(difference);
            _;
        }
        
        uint amountPaidWei = msg.value - difference;
        uint expires = now + 1 years;
        
        assert(amountPaidWei > 0);
        assert(expires> now && expires > 0);
        receipts[msg.sender].push(Receipt({amountPaidWei: amountPaidWei, timestamp: now, expires: expires}));
    }
    
    modifier DomainNameRequirements (bytes _domain) {
        require(_domain.length >= 5);
        _;
    }
    
    modifier OnlyDomainOwner (bytes _domain) {
        require(msg.sender == domains.domainsInfo[_domain].owner);
        _;
    }
    
    function DDNS() public {
        contractOwner = msg.sender;
    }
    
    function()public payable { //fallback function
        LogFallbackCalled(msg.sender, msg.value);
    }
    
    function register( bytes _domain, bytes4 _ip) public payable AvailableToBuy(_domain) PaymentHandler(_domain) DomainNameRequirements(_domain) {
        DDNSRegisterer.Domain memory domainObj = domains.domainsInfo[_domain];
        
        if(domainObj.owner == msg.sender && domainObj.expires > now){
            domains.register(_domain, _ip, domainObj.starts,  domainObj.expires + 1 years);
            LogDomainRegistered (msg.sender, _domain);
            return;
        }
        
        domains.register(_domain, _ip, now, now + 1 years);
        LogDomainRegistered (msg.sender, _domain);
    }
    
    function edit(bytes _domain, bytes4 _newIp) public OnlyDomainOwner(_domain) {
        bytes4 oldIp = domains.domainsInfo[_domain].ip;
        
        domains.edit(_domain,_newIp);
        
        LogDomainChangeIp(oldIp, _newIp, _domain);
    }
    
    function transferDomain(bytes _domain, address _newOwner) public OnlyDomainOwner(_domain) {
        address oldOwner = domains.domainsInfo[_domain].owner;
        
        domains.transferDomain(_domain, _newOwner);
        
        LogDomainTransfered(oldOwner, _newOwner, _domain);
    }
    
    function getIP(bytes _domain) public view returns (bytes4) {
        return domains.getIP(_domain);
    }

    function getContractOwner() public view returns(address){
        return contractOwner;
    }
    
    function getDomainOwner(bytes _domain) public view returns(address) {
        return domains.getDomainOwner(_domain);
    }
    
    function withdraw() public OnlyContractOwner {
        require(address(this).balance > 0);
        LogContractTokensWithdrawn(address(this).balance, now);
        msg.sender.transfer(address(this).balance);
    }
    
    function getPrice(bytes _domain) public pure returns (uint) {
        uint price = 1 ether;
        if(_domain.length == 5){
            price = 5 ether;
        } else if(5 < _domain.length && _domain.length <= 10){
            price = 2 ether;
        } else if(_domain.length > 10){
            price = 1 ether;
        } 
        else {
            revert();
        }
        return price;
    }

    function getDomainStartsDate(bytes _domain) public view returns(uint){
        return domains.getDomainStartsDate(_domain);
    }
    
    function getDomainExpirationDate(bytes _domain) public view returns(uint){
        return domains.getDomainExpirationDate(_domain);
    }
    
    // function getOwnerDomains(address _owner) public view returns(DDNSRegisterer.Domain[]){
    //     return domains.ownersInfo[_owner];
    // }

    // function geteDomainInfo(bytes _domain) public view returns(DDNSRegisterer.Domain) {
    //     return domains.domainsInfo[_domain];
    // }
    
    // function getAllReciepts() public view returns(Receipt[]){
    //     return receipts[msg.sender];
    // }
}