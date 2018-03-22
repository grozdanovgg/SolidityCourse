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
    
    modifier AvailableToBuy (bytes _domain) {
        if(msg.sender != domainsInfo[_domain].owner){
            require(domainsInfo[_domain].expires < now);
        }
        _;
    }
    
    modifier PaymentHandler (uint _cost) {
        uint difference = 0;
        if(msg.value == _cost){
            _;
        } else if( msg.value < 1 ether){
            revert();   
        } else {
            difference = msg.value - 1 ether;
            assert(difference > 0);
            msg.sender.transfer(difference);
            _;
        }
        
        receipts[msg.sender].push(Receipt({amountPaidWei: msg.value - difference, timestamp: now, expires: now + 1 years}));
    }
    
    modifier DomainNameRequirements (bytes _domain){
        require(_domain.length >= 5);
        _;
    }
    
    modifier OnlyDomainOwner (bytes _domain) {
        require(msg.sender == domainsInfo[_domain].owner);
        _;
    }
    
    modifier OnlyContractOwner (){
        require(msg.sender == contractOwner);
        _;
    }
    
    mapping(bytes => Domain) domainsInfo;
    mapping(address => Domain[]) ownerDomains;
    mapping(address => Receipt[]) public receipts;
    
    event LogDomainRegistered (address indexed _by, Domain _domain);
    event LogDomainTransfered (address indexed _from, address _to, bytes indexed _domain);
    event LogDomainChangeIp(bytes4 indexed _oldIp, bytes4 indexed _newIp, bytes indexed _domain);
    
    uint pricePerDomainYear = 1 ether;
    address contractOwner;
    
    function register(bytes _domain, bytes4 _ip) public payable AvailableToBuy(_domain) DomainNameRequirements(_domain) PaymentHandler(pricePerDomainYear){
        var domain = Domain({name: _domain, ip: _ip, owner: msg.sender, expires: now + 1 years });
        ownerDomains[msg.sender].push(domain);
        domainsInfo[_domain] = domain;
        LogDomainRegistered(msg.sender, domain);
    }
    
    function edit(bytes _domain, bytes4 _newIp) public OnlyDomainOwner(_domain){
        LogDomainChangeIp(domainsInfo[_domain].ip, _newIp, _domain);
        domainsInfo[_domain].ip = _newIp;
     }
    
    function transferDomain(bytes _domain, address _newOwner) public OnlyDomainOwner(_domain) {
        LogDomainTransfered(domainsInfo[_domain].owner, _newOwner, _domain);
        domainsInfo[_domain].owner = _newOwner;
    }
    
    function getIP(bytes _domain) public view returns (bytes4) {
        return domainsInfo[_domain].ip;
    }
    
    function getUserReceipts(address _owner) public view returns(Receipt[]){
        var receipt = receipts[_owner];
        return receipt;
    }
    
    function withdraw() public OnlyContractOwner {
        require(this.balance > 0);
        msg.sender.transfer(this.balance);
    }
    
    // function getPrice(bytes domain) public view returns (uint) {}
    
    function calculatePrice(bytes _domain) private pure returns (uint){
        uint price;
        if(_domain.length == 5){
            price = 5 ether;
        } else if(5 < _domain.length && _domain.length <= 10){
            price = 2 ether;
        } else {
            price = 1 ether;
        }
        return price;
    }
}
