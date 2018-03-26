const DDNS = artifacts.require('./DDNS.sol');

const DDNSVar = require('../test-assets/test-variables');

contract('DDNS Prices', accounts => {

    it('should return correct price for short type domain', async() => {
        const instance = await DDNS.deployed();
        const priceShort = await instance.getPrice.call(DDNSVar.validDomainNameShort);
        assert.equal(priceShort, DDNSVar.price.short, 'Price not correct');
    })

    it('should return correct price for medium type domain', async() => {
        const instance = await DDNS.deployed();
        const priceShort = await instance.getPrice.call(DDNSVar.validDomainNameMedium);
        assert.equal(priceShort, DDNSVar.price.medium, 'Price not correct');
    })

    it('should return correct price for long type domain', async() => {
        const instance = await DDNS.deployed();
        const priceShort = await instance.getPrice.call(DDNSVar.validDomainNameLong);
        assert.equal(priceShort, DDNSVar.price.long, 'Price not correct');
    })
});
