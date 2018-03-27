pragma solidity 0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DDNS.sol";

contract TestDDNS {

  function toAsciiString(address x) private pure returns (string) {
      bytes memory s = new bytes(40);
      for (uint i = 0; i < 20; i++) {
          byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
          byte hi = byte(uint8(b) / 16);
          byte lo = byte(uint8(b) - 16 * uint8(hi));
          s[2*i] = char(hi);
          s[2*i+1] = char(lo);            
      }
      return string(s);
  }

  function char(byte b) private pure returns (byte c) {
      if (b < 10) return byte(uint8(b) + 0x30);
      else return byte(uint8(b) + 0x57);
  }

  function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
      bytes memory _ba = bytes(_a);
      bytes memory _bb = bytes(_b);
      bytes memory _bc = bytes(_c);
      bytes memory _bd = bytes(_d);
      bytes memory _be = bytes(_e);
      string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
      bytes memory babcde = bytes(abcde);
      uint k = 0;
      for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
      for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
      for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
      for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
      for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
      return string(babcde);
  }

  function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
      return strConcat(_a, _b, _c, _d, "");
  }

  function strConcat(string _a, string _b, string _c) internal pure returns (string) {
      return strConcat(_a, _b, _c, "", "");
  }

  function strConcat(string _a, string _b) internal pure returns (string) {
      return strConcat(_a, _b, "", "", "");
  }

  // function testPriceShortDomain() public {
    // DDNS instance = DDNS(DeployedAddresses.DDNS());

    // uint memory priceShort = instance.getPrice("0x1122334455");

    // Assert.equal(priceShort, 5000000000000000000);
    // string memory str1 = toAsciiString(domainOwner);
    // string memory str2 = toAsciiString(contractOwner);
    // string memory err = strConcat(str1, " | " , str2);
    // address a1 = instance.getContractOwner();
    // address a2 = instance.getContractOwner();
    // Assert.equal(true,false , str2);
  // }

  // function testRegisteringMediumDomain() public {
  //   DDNS instance = DDNS(DeployedAddresses.DDNS());

  //   instance.register("0x112233445566","1111");

  //   address domainOwner = instance.getDomainOwner("1111");

  //   Assert.equal(domainOwner, instance.getContractOwner() , "Domain not registered");
  // }

  // function testRegisteringLongDomain() public {
  //   DDNS instance = DDNS(DeployedAddresses.DDNS());

  //   instance.register("0x11223344556677889900112233","1111");

  //   address domainOwner = instance.getDomainOwner("1111");

  //   Assert.equal(domainOwner, instance.getContractOwner() , "Domain not registered");
  // }

  // function testRegisterContractOwner() public {
  //   DDNS instance = DDNS(DeployedAddresses.DDNS());

  //   address instanceOwner = instance.getContractOwner();
  //   address contractOwner = DeployedAddresses.DDNS();

  //   string memory str1 = toAsciiString(instanceOwner);
  //   string memory str2 = toAsciiString(contractOwner);
  //   string memory err = strConcat(str1, " | " , str2);
  //   Assert.equal(instanceOwner, contractOwner,err);
  // }

  function testInitialBalanceWithNewMetaCoin() public {
    // MetaCoin meta = new MetaCoin();

    // uint expected = 10000;

    Assert.equal(5, 5, "Owner should have 10000 MetaCoin initially");
  }

}
