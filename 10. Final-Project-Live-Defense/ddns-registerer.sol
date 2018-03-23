pragma solidity 0.4.19;

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
