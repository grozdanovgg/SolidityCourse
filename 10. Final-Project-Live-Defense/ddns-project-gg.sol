pragma solidity 0.4.19;

contract DDNS {
    // struct Receipt{
    //     uint amountPaidWei;
    //     uint timestamp;
    //     uint expires;
    // }
    
    struct Domain{
        bytes name;
        bytes4 ip;
        address owner;
        uint expires;
    }
    
    modifier AvailableToBuy (bytes _domain) {
        if(msg.sender != domainsInfo[_domain].owner){
            require(domainsInfo[_domain].expires < now);
        }
        _;
    }
    
    modifier PaymentHandler {
        if(msg.value == 1 ether){
            _;
        } else if( msg.value < 1 ether){
            revert();   
        } else {
            uint difference = msg.value - 1 ether;
            assert(difference > 0);
            msg.sender.transfer(difference);
            _;
        }
    }
    
    modifier DomainNameRequirements (bytes _domain){
        require(_domain.length >= 5);
        _;
    }
    
    modifier OnlyDomainOwner (bytes _domain) {
        require(msg.sender == domainsInfo[_domain].owner);
        _;
    }
    
    mapping(bytes => Domain) domainsInfo;
    mapping(address => Domain[]) ownerDomains;
    
    //This will create an automatic getter with 2 arguments: address and index of receipt
    // mapping(address => Receipt[]) public receipts;
    
    address contactOwner;
    
    //the domain is bytes, because string is UTF-8 encoded and we cannot get its length
    //the IP is bytes4 because it is more efficient in storing the sequence
    function register(bytes _domain, bytes4 _ip) public payable AvailableToBuy(_domain) PaymentHandler{
        var domain = Domain({name: _domain, ip: _ip, owner: msg.sender, expires: now + 1 years });
        ownerDomains[msg.sender].push(domain);
        domainsInfo[_domain] = domain;
    }
    
     function edit(bytes _domain, bytes4 _newIp) public OnlyDomainOwner(_domain){
         domainsInfo[_domain].ip = _newIp;
     }
    
    // function transferDomain(bytes domain, address newOwner) public {}
    
    // function getIP(bytes domain) public view returns (bytes4) {}
    
    // function getPrice(bytes domain) public view returns (uint) {}
}
