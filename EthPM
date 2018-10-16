# EthPM

Large Repo of contracts adn libraries stored on IPFS and usable through Truffle.

Let's supppose we want our contract to use StardardToken.sol contract's functions and variables.

We run with truffle `truffle install zeppelin` because StandardToken.sol was designed by ZeppelinOS

Now we realize a folder was created on our truffle project folder with the name: `installed_contracts`.

On this folder, we will have all of the different collections of contracts. for example:
```
kr0@Legion-Y520:~/Desktop/pae19/installed_contracts$ ls
oraclize-api  zeppelin
```
As we see, we have 2 different contract collections: The famous organizations Oraclize.it and ZeppelinOS.

We can see different things when we enter into one of the installed collections, for example zeppelin:
```
kr0@Legion-Y520:~/Desktop/pae19/installed_contracts/zeppelin$ ls
contracts  ethpm.json  lock.json  lock.uri
```
As we see we have a very similar structure as whie we work with NPM. The ethpm.json will be the equivalent to the package.json and has this structure:

```
{
  "authors": [
    "Manuel Araoz <xxxx@yyyy.com>"
  ],
  "license": "MIT",
  "description": "Secure Smart Contract library for Solidity",
  "keywords": [
    "solidity",
    "ethereum",
    "smart",
    "contracts",
    "security",
    "zeppelin"
  ],
  "links": {},
  "sources": [
    "./contracts/Bounty.sol",
    "./contracts/DayLimit.sol",
    "./contracts/ECRecovery.sol",
    "./contracts/LimitBalance.sol",
    "./contracts/MerkleProof.sol",
    "./contracts/ReentrancyGuard.sol",
    "./contracts/crowdsale/CappedCrowdsale.sol",
    "./contracts/crowdsale/Crowdsale.sol",
    "./contracts/crowdsale/FinalizableCrowdsale.sol",
    "./contracts/crowdsale/RefundableCrowdsale.sol",
    "./contracts/crowdsale/RefundVault.sol",
    "./contracts/examples/SampleCrowdsale.sol",
    "./contracts/examples/SimpleToken.sol",
    "./contracts/lifecycle/Destructible.sol",
    "./contracts/lifecycle/Migrations.sol",
    "./contracts/lifecycle/Pausable.sol",
    "./contracts/lifecycle/TokenDestructible.sol",
    "./contracts/math/Math.sol",
    "./contracts/math/SafeMath.sol",
    "./contracts/ownership/CanReclaimToken.sol",
    "./contracts/ownership/Claimable.sol",
    "./contracts/ownership/Contactable.sol",
    "./contracts/ownership/DelayedClaimable.sol",
    "./contracts/ownership/HasNoContracts.sol",
    "./contracts/ownership/HasNoEther.sol",
    "./contracts/ownership/HasNoTokens.sol",
    "./contracts/ownership/NoOwner.sol",
    "./contracts/ownership/Ownable.sol",
    "./contracts/payment/PullPayment.sol",
    "./contracts/token/BasicToken.sol",
    "./contracts/token/BurnableToken.sol",
    "./contracts/token/ERC20.sol",
    "./contracts/token/ERC20Basic.sol",
    "./contracts/token/LimitedTransferToken.sol",
    "./contracts/token/MintableToken.sol",
    "./contracts/token/PausableToken.sol",
    "./contracts/token/SafeERC20.sol",
    "./contracts/token/StandardToken.sol",
    "./contracts/token/TokenTimelock.sol",
    "./contracts/token/VestedToken.sol"
  ],
  "dependencies": {},
  "manifest_version": 1,
  "package_name": "zeppelin",
  "version": "1.3.0"
}
```

We can see all the different dependencies, sources, version, license etc...

So now, we got access to every Zeppelin contract, and we don't need to go to their GitHub to get it's contract code and all of it's depencencies.

```
~/Desktop/pae19/installed_contracts/zeppelin/contracts$ ls
Bounty.sol  DayLimit.sol    **examples**   LimitBalance.sol  MerkleProof.sol  **payment**              **token**
**crowdsale**   ECRecovery.sol  **lifecycle**  **math**              **ownership**        ReentrancyGuard.sol
```
We can see all the contracts listed and ordered in folders if needed.


So now we have our Solidity code:
```
pragma solidity ^0.4.24;


import "zeppelin/token/StandardToken.sol";

contract Test is StandardToken{
  constructor () {
    //////
  }

  ////////
}

```

This code example will import the contract StandardToken.sol from zeppelin/token ethpm package.

The same happens with the migrations.
We can use it's artifact too:

**File: ./migrations/2_deploy_contracts.js**
```
var STDToken = artifacts.require("zeppelin/token/StandardToken");
var Test = artifacts.require("Test");

module.exports = function(deployer) {
  //////////
  });
};
```

