pragma solidity 0.4.19;

import "./ddns-registerer-library.sol";

contract DDNS {
    using DDNSRegisterer for DDNSRegisterer.Domain;
    
    DDNSRegisterer.Domain domains;
    
    struct Receipt{
        uint amountPaidWei;
        uint timestamp;
        uint expires;
    }
    
    event LogDomainRegistered (address indexed by, bytes domain);
    event LogDomainTransfered (address indexed from, address to, bytes indexed domain);
    event LogDomainChangeIp (bytes4 indexed oldIp, bytes4 indexed newIp, bytes indexed domain);
    event ContractTokensWithdrawn (uint tokensAmmount, uint date);
    
    modifier AvailableToBuy (bytes _domain) {
        DDNSRegisterer.Domain storage domainData = domains.domainsInfo[_domain];
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
    
    modifier OnlyContractOwner () {
        require(msg.sender == contractOwner);
        _;
    }
    
    mapping(address => Receipt[]) public receipts;
    
    address contractOwner;
    
    function DDNS() public {
        contractOwner = msg.sender;
    }
    
    function()public payable { //fallback function
    }
    
    function register( bytes _domain, bytes4 _ip) public payable AvailableToBuy(_domain) DomainNameRequirements(_domain) PaymentHandler(_domain) {
        domains.register(_domain, _ip);
        LogDomainRegistered (msg.sender, _domain);
    }
    
    function edit(bytes _domain, bytes4 _newIp) public OnlyDomainOwner(_domain) {
        LogDomainChangeIp(domains.domainsInfo[_domain].ip, _newIp, _domain);
        domains.edit(_domain,_newIp);
    }
    
    function transferDomain(bytes _domain, address _newOwner) public OnlyDomainOwner(_domain) {
        LogDomainTransfered(domains.domainsInfo[_domain].owner, _newOwner, _domain);
        domains.transferDomain(_domain, _newOwner);
    }
    
    function getIP(bytes _domain) public view returns (bytes4) {
        return domains.getIP(_domain);
    }
    
    function withdraw() public OnlyContractOwner {
        require(address(this).balance > 0);
        ContractTokensWithdrawn(address(this).balance, now);
        msg.sender.transfer(address(this).balance);
    }
    
    function getPrice(bytes _domain) public pure returns (uint) {
        uint price;
        if(_domain.length == 5){
            price = 5 ether;
        } else if(5 < _domain.length && _domain.length <= 10){
            price = 2 ether;
        } else if(_domain.length > 10){
            price = 1 ether;
        } else {
            revert();
        }
        return price;
    }
}

library DDNSRegisterer {
    
    struct Domain{
        mapping(bytes => Domain) domainsInfo;
        mapping(address => Domain[]) ownerDomains;
        bytes name;
        bytes4 ip;
        address owner;
        uint starts;
        uint expires;
    }
    
    function register(Domain storage self, bytes _domain, bytes4 _ip) public returns(bool) {
        self.ownerDomains[msg.sender].push(Domain({name: _domain, ip: _ip, owner: msg.sender, starts: now, expires: now + 1 years }));
        self.domainsInfo[_domain] = Domain({name: _domain, ip: _ip, owner: msg.sender, starts: now, expires: now + 1 years });
    }
    
    function edit(Domain storage self, bytes _domain, bytes4 _newIp) public {
        self.domainsInfo[_domain].ip = _newIp;
    }
    
    function transferDomain(Domain storage self, bytes _domain, address _newOwner) public {
        self.domainsInfo[_domain].owner = _newOwner;
    }
    
    function getIP(Domain storage self, bytes _domain) public view returns (bytes4) {
        return self.domainsInfo[_domain].ip;
    }
}

