1. 1.DDNS

### Mandatory Tasks

- **DONE (20%) (lecture 6)** Public method to register a domain, giving the domain name and an ip address it should point to. A registered domain cannot be bought and is owned by the caller of the method. **The domain registration should cost 1 ETH and the domain should be registered for 1 year**. After 1 year, anyone is allowed to buy the domain again. The domain registration can be extended by 1 year if the domain owner calls the register method and pays 1 ETH. The domain can be any string with length **more than 5 symbols**.
- **DONE (10%) (lecture 6)** Public method to edit a domain. Editing a domain is changing the ip address it points to. The operation is free. Only the owner of the domain can edit the domain.
- **DONE (10%) (lecture 6)** Public method to transfer the domain ownership to another user. The operation is free. Only the domain owner can transfer his domains.
- **DONE (10%) (lecture 6)** Public method to receive an IP based on a given domain.
- **(10%) (lecture 6)** Public method that returns a list of all receipts by a certain account. A receipt is a domain purchase/extension and contains the price, timestamp of purchase and expiration date of the domain.

- **DONE (40%) (lecture 10) Unit tests for all the methods in your contract (including all aforementioned). The tests should handle all constraints around the contract**. Example with DDNS: A test can be one that tries to register an already registered domain. The test is passed if the operation fails (expected behavior).

#### Optional Tasks:

- **DONE (5%) (lecture 5)** Use **contract events** to signify that an activity has taken place in your contract. Events can be for domain registration / transfer for example.
- **(20%) (lecture 8)** (Get ABI and bytecode from with "truffle deploy") Create a basic website with MetaMask that connects to a contract (published in a test net or local blockchain). The application should allow **at least one** operation with the contract (Domain registration or Store purchase are examples).
- **DONE (5%) (lecture 6)** Dynamic pricing. For DDNS, the base price can increase if a short domain name is bought.
- **DONE (5%) (lecture 6)** Public method to withdraw the funds from the contract. **This should be called only from the contract owner** (the address which initially created the contract).

1. 2.Submission

Submission deadline: **29.03.2018 23:59**

Projects should be submitted as archive files on the course&#39; page under the &quot;Final Project - Live Defense&quot; heading. A button for uploading files will become visible two weeks before the submission deadline.