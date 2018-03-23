const DDNS = artifacts.require('./DDNS.sol');

contract('DDNS', accounts => {
  const validDomainNameShort = '12345';
  const validDomainNameMedium = '123456789';
  const validDomainNameLong = '1234567890123';
  const invalidDomainName = '123';

  const ip = '1111';

  it('should register contract creator as owner', async () => {
    const instance = await DDNS.deployed();
    const contractOwner = await instance.getContractOwner.call();
    const expectedOwner = accounts[0];

    assert.equal(contractOwner, accounts[0], 'contract owner is not the contract creator');
  });

  it('should be able to register short domain', async () => {
    const instance = await DDNS.deployed();
    const registered = await instance.register(validDomainNameShort, ip, { from: accounts[0], value: web3.toWei(6, "ether") });

    assert.equal(5, 5, 'no..')
  });
});
