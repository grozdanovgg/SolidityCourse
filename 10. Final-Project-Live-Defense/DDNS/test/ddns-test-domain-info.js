const DDNS = artifacts.require('./DDNS.sol');
const DDNSVar = require('../test-assets/test-variables');

contract('DDNS domain info', accounts => {
    it('should recieve the correct IP of a domain', async() => {
        const instance = await DDNS.deployed();
        const ip = '0x12340000';
        await instance.register(DDNSVar.validDomainNameLong, ip, { from: accounts[0], value: DDNSVar.price.long });

        const domainIp = await instance.getIP.call(DDNSVar.validDomainNameLong);

        assert.equal(ip, domainIp, 'Did not return the correct IP of the domain');
    });

    it('should get reciepts for owner', async() => {
        const instance = await DDNS.deployed();
        await instance.register(DDNSVar.validDomainNameMedium, DDNSVar.validIp, { from: accounts[0], value: DDNSVar.price.medium });
        try {
            await instance.receipts.call(accounts[0], 0);
            await instance.receipts.call(accounts[0], 1);
            assert(true);
            return;
        } catch (error) {
            assert(false);
            return;
        }
        assert.fail('Expected throw not received');
    });
});
