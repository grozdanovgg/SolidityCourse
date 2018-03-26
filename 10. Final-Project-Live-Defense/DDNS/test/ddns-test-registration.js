const DDNS = artifacts.require('./DDNS.sol');
const DDNSVar = require('../test-assets/test-variables');

const increaseTime = function(duration) {
    const id = Date.now()

    return new Promise((resolve, reject) => {
        web3.currentProvider.sendAsync({
            jsonrpc: '2.0',
            method: 'evm_increaseTime',
            params: [duration],
            id: id,
        }, err1 => {
            if (err1) return reject(err1)

            web3.currentProvider.sendAsync({
                jsonrpc: '2.0',
                method: 'evm_mine',
                id: id + 1,
            }, (err2, res) => {
                return err2 ? reject(err2) : resolve(res)
            })
        })
    })
}

contract('DDNS Domain registration', accounts => {

    it('should register contract creator as owner', async() => {
        const instance = await DDNS.deployed();
        const contractOwner = await instance.getContractOwner.call();
        const expectedOwner = accounts[0];

        assert.equal(contractOwner, accounts[0], 'contract owner is not the contract creator');
    });

    it('should be able to register short domain for 5 ETH', async() => {
        const instance = await DDNS.deployed();
        await instance.register(DDNSVar.validDomainNameShort, DDNSVar.validIp, { from: accounts[0], value: DDNSVar.price.short });
        const domainOwner = await instance.getDomainOwner(DDNSVar.validDomainNameShort);

        assert.equal(domainOwner, accounts[0], 'Domain is not registered to the caller');
    });

    it('should be able to register medium domain for 2 ETH', async() => {
        const instance = await DDNS.deployed();
        await instance.register(DDNSVar.validDomainNameMedium, DDNSVar.validIp, { from: accounts[0], value: DDNSVar.price.medium });
        const domainOwner = await instance.getDomainOwner(DDNSVar.validDomainNameMedium);

        assert.equal(domainOwner, accounts[0], 'Domain is not registered to the caller');
    });

    it('should be able to register long domain for 1 ETH', async() => {
        const instance = await DDNS.deployed();
        await instance.register(DDNSVar.validDomainNameLong, DDNSVar.validIp, { from: accounts[0], value: DDNSVar.price.long });
        const domainOwner = await instance.getDomainOwner(DDNSVar.validDomainNameLong);

        assert.equal(domainOwner, accounts[0], 'Domain is not registered to the caller');
    });

    it('should NOT be able to register long domain for 0.9 ETH', async() => {
        const instance = await DDNS.deployed();

        try {
            const fn = await instance.register(DDNSVar.validDomainNameLong, DDNSVar.validIp, { from: accounts[0], value: web3.toWei(0.9, 'ether') });

        } catch (error) {
            assert(true, error);
            return;
        }
        assert.fail('Expected throw not received');
    });

    it('should NOT be able to register medium domain for 1.5 ETH', async() => {
        const instance = await DDNS.deployed();

        try {
            const fn = await instance.register(DDNSVar.validDomainNameMedium, DDNSVar.validIp, { from: accounts[0], value: web3.toWei(1.5, 'ether') });

        } catch (error) {
            assert(true, error);
            return;
        }
        assert.fail('Expected throw not received');
    });

    it('should NOT be able to register short domain for 3 ETH', async() => {
        const instance = await DDNS.deployed();

        try {
            const fn = await instance.register(DDNSVar.validDomainNameShort, DDNSVar.validIp, { from: accounts[0], value: web3.toWei(3, 'ether') });

        } catch (error) {
            assert(true, error);
            return;
        }
        assert.fail('Expected throw not received');
    });

    it('should return the extra tokens payed for the domain (Pay 6 tokens for short, expext 1 to be returned', async() => {
        const instance = await DDNS.deployed();
        const contractAddress = await instance.address;
        const initialBalance = web3.eth.getBalance(contractAddress);

        await instance.register(DDNSVar.validDomainNameShort, DDNSVar.validIp, { from: accounts[0], value: web3.toWei(6, 'ether') });

        // const domainOwner = await instance.getDomainOwner(DDNSVar.validDomainNameShort);
        const laterBalance = web3.eth.getBalance(contractAddress);

        assert.equal(laterBalance - initialBalance, web3.toWei(5, 'ether'), 'The ammount payed is incorrect');
    });

    it('newly registerd domain should expire after 1 year', async() => {

        const instance = await DDNS.deployed();
        const domainName = '0x1111111111111111';
        const yearInSeconds = 31536000;

        const reg = await instance.register(domainName, DDNSVar.validIp, { from: accounts[0], value: DDNSVar.price.short });

        const starts = await instance.getDomainStartsDate.call(domainName);
        const expires = await instance.getDomainExpirationDate.call(domainName);
        const domainOwner = await instance.getDomainOwner.call(domainName);

        assert.equal(starts.toNumber() + yearInSeconds, expires.toNumber(), 'Expiration date is not correct');
    });

    it('should NOT be able to registrer domain, that is taken, before it expires', async() => {
        const instance = await DDNS.deployed();
        try {
            await instance.register(DDNSVar.validDomainNameShort, DDNSVar.validIp, { from: accounts[1], value: DDNSVar.price.short });
        } catch (error) {
            assert(true, error);
            return;
        }
        assert.fail('Domain is not registered to the caller');
    });

    it('after 1 year, anyone is allowed to buy the domain again', async() => {
        const instance = await DDNS.deployed();
        // const oldTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp;

        await increaseTime(60 * 60 * 24 * 400);
        await instance.register(DDNSVar.validDomainNameLong, DDNSVar.validIp, { from: accounts[2], value: DDNSVar.price.long });

        const domainOwner = await instance.getDomainOwner(DDNSVar.validDomainNameLong);

        assert.equal(domainOwner, accounts[2], 'Domain is not registered to the caller');
    });

    it('should extend registration by 1 year if the domain owner calls the register method and pays the price', async() => {
        const instance = await DDNS.deployed();
        const oldExpDate = await instance.getDomainExpirationDate(DDNSVar.validDomainNameLong);

        await instance.register(DDNSVar.validDomainNameLong, DDNSVar.validIp, { from: accounts[2], value: DDNSVar.price.long });

        const newExpDate = await instance.getDomainExpirationDate(DDNSVar.validDomainNameLong);

        assert(newExpDate - oldExpDate >= 60 * 60 * 24 * 365, 'Domain exp date not extended');
    });
});
