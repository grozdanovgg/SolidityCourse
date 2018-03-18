pragma solidity ^0.4.21;

library SafeMath {
    
    function add(int256 a, int256 b) internal pure returns(int256){
        int256 c = a + b;
        assert(c - a == b);
        assert(c - b == a);
        return c;
    }
    
    function substract( int256 a, int256 b) internal pure returns(int256){
        int256 c = a - b;
        assert(c + b == a);
        assert(a - c == b);
        return c;
    }
    
    function multiply ( int256 a, int256 b) internal pure returns(int256) {
        int256 c = a*b;
        if(a != 0 && b != 0){
            assert( c / a == b );
            assert( c / b == a );
        }
        return c;
    }
}

contract Owned {
    address public owner;
    
    function Owned() public{
        owner = msg.sender;
    }
    
    function changeOwner(address newOwner) public {
        require(msg.sender == owner);
        owner = newOwner;
    }
}

contract Custom is Owned{
    using SafeMath for int256;
    
    int256 public customNumber;
    uint256 lastStateChange;
    
    function changeCustomNumber () public {
        require(msg.sender == owner);
        customNumber = customNumber.add( int256(now) % 256);
        if(lastStateChange == 0){
            lastStateChange = now - 1;
        }
        customNumber = customNumber.multiply( int256(now - lastStateChange));
        customNumber = customNumber.substract( int256(block.gaslimit));
        
        lastStateChange = now;
    }
}
