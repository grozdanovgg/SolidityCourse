
#### Instructions to deploy and run the DDNS DAPP:
1. open new cmd.exe
2. navigat e to ./DDNS root folder
3. run "npm install"
4. run "truffle compile"
5. run "truffle develop"
6. copy the Memonics to safe place: "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat"
7. run "deploy"
8. copy to safe place the address after "DDNS: "  (for example: 0xf25186b5081ff5ce73482ad761db0eb0d25abfbf)
9. copy to safe place the address after "Truffle Develop started at " (for example: http://127.0.0.1:9545)
10. open ./build/contracts/DDNS.json file with text editor
11. find ' "abi": ' and copy it's array value;
12. open ./web3_dapp/script.js file
13. find "var abi = " and paste the value;
14. find "var address = " and paste the value saved before "DDNS: " as  a string
15. install Google hrome
16. Install MetaMask extension
17. open MetaMask
18. click in Restore from phrase
19. Paste the Memonics previously savd
20. choose a password
21. click to top-left Network chooser
22. click on Custom RPC
23. enter the addres saved for "Truffle Develop started at" (http://127.0.0.1:9545) and save
24. open new cmd.exe
25. navigate to ./web3_dapp folder
26. run http-server
27. open browser  the addres after "Available on: " (for example: http://localhost:8080)

#### Congratulations, you have succesfully runned the DAPP!
#### You can start using it.
