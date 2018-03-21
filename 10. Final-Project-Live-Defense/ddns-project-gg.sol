pragma solidity 0.4.19;

contract DDNS {
    struct Receipt{
        uint amountPaidWei;
        uint timestamp;
        uint expires;
    }
    
    struct Domain{
        bytes name;
        bytes4 ip;
        address owner;
        uint expires;
    }
    
    modifier AvailableDomain (bytes _domain) {
        require(domainsInfo[_domain].owner != 0);
        require(domainsInfo[_domain].expires < now);
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
    
    mapping(bytes => Domain) domainsInfo;
    mapping(address => Domain[]) ownerDomains;
    
    //This will create an automatic getter with 2 arguments: address and index of receipt
    mapping(address => Receipt[]) public receipts;
    
    //the domain is bytes, because string is UTF-8 encoded and we cannot get its length
    //the IP is bytes4 because it is more efficient in storing the sequence
    function register(bytes _domain, bytes4 _ip) public payable AvailableDomain(_domain) PaymentHandler{
        var domain = Domain({name: _domain, ip: _ip, owner: msg.sender, expires: now + 1 years });
        ownerDomains[msg.sender].push(domain);
        domainsInfo[_domain] = domain;
    }
    
    function edit(bytes domain, bytes4 newIp) public {}
    
    function transferDomain(bytes domain, address newOwner) public {}
    
    function getIP(bytes domain) public view returns (bytes4) {}
    
    function getPrice(bytes domain) public view returns (uint) {}
}
