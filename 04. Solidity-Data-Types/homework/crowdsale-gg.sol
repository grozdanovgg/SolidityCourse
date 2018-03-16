pragma solidity ^0.4.21;

contract TokenSaleIco {
    
    function TokenSaleIco () public {
        owner = msg.sender;
        dateCretedContract = now;
    }
    
    mapping (address => uint) public balances;
    
    address owner;
    uint dateCretedContract;
    
    modifier crowdsaleState {
        require( now - dateCretedContract <= 5 minutes );
        _;
    }
    
    modifier openState {
        require ( now - dateCretedContract > 5 minutes);
        _;
    }
    
    modifier hasEnoughTokens (uint _tokensAmmount){
        require(balances[msg.sender] > _tokensAmmount);
        _;
    }
    
    function crowdsaleBuy () public payable crowdsaleState {
        require(msg.value > 0);
        balances[msg.sender] += exchangeWeiToTokens(msg.value);
    }
    
    function transferTokens (address _recipientAddress, uint _tokensAmmount) public openState hasEnoughTokens(_tokensAmmount) {
        balances[msg.sender] -= _tokensAmmount;
        balances[_recipientAddress] += _tokensAmmount;
    }
    
    function withdrawEther (uint ammount) public {
        require(address(this).balance > ammount);
        require(now - dateCretedContract > 1 years);
        owner.transfer(exchangeEthToWei(ammount));
    }
    
    // Private functions
    function exchangeWeiToTokens(uint weisUnits) private pure returns(uint){
        return (weisUnits * 5) / 1000000000000000000;
    }
    
    function exchangeEthToWei (uint _etherTokens) private pure returns(uint){
        return _etherTokens * 1000000000000000000;
    }
}
