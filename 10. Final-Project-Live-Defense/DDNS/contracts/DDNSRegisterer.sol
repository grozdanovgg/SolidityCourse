pragma solidity 0.4.19;

library DDNSRegisterer {
    
    struct Domain{
        bytes name;
        bytes4 ip;
        address owner;
        uint starts;
        uint expires;
    }
    
    struct DomainsData{
        mapping(bytes => Domain) domainsInfo;
        mapping(address => Domain[]) ownersInfo;
    }
    
    function register(DomainsData storage self, bytes _domain, bytes4 _ip, uint _starts, uint _expires) public returns(bool) {
        Domain memory domainObj = Domain({name: _domain, ip: _ip, owner: msg.sender, starts: _starts, expires:_expires });
        self.ownersInfo[msg.sender].push(domainObj);
        self.domainsInfo[_domain] = domainObj;
    }
    
    function edit(DomainsData storage self, bytes _domain, bytes4 _newIp) public {
        self.domainsInfo[_domain].ip = _newIp;
    }
    
    function transferDomain(DomainsData storage self, bytes _domain, address _newOwner) public {
        self.domainsInfo[_domain].owner = _newOwner;
    }
    
    function getIP(DomainsData storage self, bytes _domain) public view returns (bytes4) {
        return self.domainsInfo[_domain].ip;
    }
    
    function getDomainOwner(DomainsData storage self, bytes _domain) public view returns(address) {
        return self.domainsInfo[_domain].owner;
    }
    
    function getDomainStartsDate(DomainsData storage self, bytes _domain) public view returns(uint){
        return self.domainsInfo[_domain].starts;
    }
    
    function getDomainExpirationDate(DomainsData storage self, bytes _domain) public view returns(uint){
        return self.domainsInfo[_domain].expires;
    }
}
