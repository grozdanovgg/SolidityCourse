const DDNS = artifacts.require('./DDNS.sol');
const DDNSVar = require('../test-assets/test-variables');

contract('DDNS Domain control', accounts => {

    it('should change domain ownership', async() => {
        const instance = await DDNS.deployed();

        await instance.register(DDNSVar.validDomainNameShort, DDNSVar.validIp, { from: accounts[0], value: DDNSVar.price.short });
        await instance.transferDomain(DDNSVar.validDomainNameShort, accounts[1], { from: accounts[0] });

        const domainOwner = await instance.getDomainOwner(DDNSVar.validDomainNameShort);

        assert.equal(domainOwner, accounts[1], 'Domain is not transfered');
    });

    it('should NOT be able change domain ownership if called by stranger', async() => {
        const instance = await DDNS.deployed();

        try {
            await instance.transferDomain(DDNSVar.validDomainNameShort, accounts[0], { from: accounts[0] });
        } catch (error) {
            assert(true, error);
            return;
        }
        assert.fail('Expected throw not received');
    });

    it('should edit domain ip address', async() => {
        const instance = await DDNS.deployed();
        const domainOldIp = await instance.getIP.call(DDNSVar.validDomainNameShort);
        await instance.edit(DDNSVar.validDomainNameShort, DDNSVar.validIp2, { from: accounts[1] });

        const domainNewIp = await instance.getIP.call(DDNSVar.validDomainNameShort);

        const ipChanged = domainOldIp != domainNewIp;

        assert(ipChanged, 'IP not changed');
    });

    it('should NOT edit domain ip address, if called by stranger', async() => {
        const instance = await DDNS.deployed();
        const domainOldIp = await instance.getIP.call(DDNSVar.validDomainNameShort);
        try {
            await instance.edit(DDNSVar.validDomainNameShort, DDNSVar.validIp2, { from: accounts[2] });
        } catch (error) {
            assert(true, error);
            return;
        }
        assert.fail('Expected throw not received');
    });
});
