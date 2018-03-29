
#### Instructions to deploy and run the DDNS DAPP:
1. open new cmd.exe
3. navigat
4. e to ./DDNS root folder
4. run "npm install"
5. run "truffle compile"
6. run "truffle develop"
7. copy the Memonics to safe place: "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat"
8. run "deploy"
9. copy to safe place the address after "DDNS: "  (for example: 0xf25186b5081ff5ce73482ad761db0eb0d25abfbf)
10. copy to safe place the address after "Truffle Develop started at " (for example: http://127.0.0.1:9545)
11. open ./build/contracts/DDNS.json file with text editor
12. find ' "abi": ' and copy it's array value;
13. open ./web3_dapp/script.js file
14. find "var abi = " and paste the value;
15. find "var address = " and paste the value saved before "DDNS: " as  a string
16. install Google hrome
17. Install MetaMask extension
18. open MetaMask
19. click in Restore from phrase
20. Paste the Memonics previously savd
21. choose a password
22. click to top-left Network chooser
23. click on Custom RPC
24. enter the addres saved for "Truffle Develop started at" (http://127.0.0.1:9545) and save
25. open new cmd.exe
26. navigate to ./web3_dapp folder
27. run http-server
28. open browser  the addres after "Available on: " (for example: http://localhost:8080)

#### Congratulations, you have succesfully runned the DAPP!
#### You can start using it.