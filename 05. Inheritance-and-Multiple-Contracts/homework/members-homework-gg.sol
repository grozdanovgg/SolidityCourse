pragma solidity ^0.4.21;

contract Owned {
    address public owner;
    function Owned () public {
        owner = msg.sender;
    }
}

library MembersControl {
    
    struct Member {
        address memberAddress;
        uint256 totalEthDonated;
        uint256 lastDonationDate;
        uint256 lastEthAmmountDonated;
    }
    
    struct Members {
        mapping (address => Member) members;
    }
    
    function addMemeber (Members storage _members, address _memberAddress) public {
        _members.members[_memberAddress] = Member({
            memberAddress: _memberAddress,
            totalEthDonated:0,
            lastDonationDate: 0,
            lastEthAmmountDonated: 0
        });
    }
    
    function deleteMember (Members storage _members, address _memberAddress) public {
        delete _members.members[_memberAddress];
    }
}

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

contract Membership is Owned {

    using SafeMath for int256;
    using MembersControl for MembersControl.Members;
    
    // address applicant;
    MembersControl.Members members;
    
    modifier OnlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    function Membership () public {
         members.addMemeber(msg.sender);
    }
    
    function addMemeber (address _memberAddress) public {
        members.addMemeber(_memberAddress);
    }
    
    function removeMember (address _memberAddress) public OnlyOwner {
        require(now - members.members[_memberAddress].lastDonationDate > 1 hours);
        members.deleteMember(_memberAddress);
    }
    
    function killContract () public OnlyOwner{
        selfdestruct(msg.sender);
    }
}
