# Parity.

Parity is an Ethereum cliend build with Rust. It allows us **to get up an ethereum node running on our machine and make client calls to it to deployr our contracts, send transactions etc..**

By default, Parity Ethereum runs a JSON-RPC HTTP server on port :8545 and a Web-Sockets server on port :8546. This is fully configurable and supports a number of APIs.

Installation:

To go fast, the best way to do it if you work on MAC or Linux is to Online install Binaries:

Before any installation, we should install a few depencencies by doing:

`$ apt-get install build-essential openssl libssl-dev libudev-dev`

Then, to install it we execute the following command: `$ bash <(curl https://get.parity.io -L)`

Now that we have Parity Installed, we run `$ parity --version` obtaining the following:
```
Parity
  version Parity-Ethereum/v2.0.0-beta-6eae372-20180717/x86_64-linux-gnu/rustc1.27.1
```

Why i need an Eth client if now i can:
- Send transactions(Metamask).
- Deploy my smartcontracts(Remix).
- Or query the blockchain(Block Explorers, Remix contract calls..).

It's true, but think about that. Metamask is connected to Infura's nodes to execute your requests, and that nodes must run an Eth client to be able to bradcast your tx.
The same sappens with Remix.
And obviously every block explorer or chain monitor must run a eth node behind to be able to display all that information.

So finally, it's all about trustfulness, if you travel through Infura's nodes while working with metamask, you are trusting that they aren't sending you false info, ignoring your tx sent etc..
Also **you can't mine ether without having a full node.**


Working with the parity:

If we execute parity by running `$ parity` without any configuration parameters, we start seeing this:
```
2018-09-23 15:04:38  Starting Parity-Ethereum/v2.0.0-beta-6eae372-20180717/x86_64-linux-gnu/rustc1.27.1  //Parity version and Rustc version.
2018-09-23 15:04:38  Keys path /home/kr0/.local/share/io.parity.ethereum/keys/Foundation   //Path where Parity can access to an UTC File with our accounts in order to use it.
2018-09-23 15:04:38  DB path /home/kr0/.local/share/io.parity.ethereum/chains/ethereum/db/906a34e69aec8c0d  //Path where Parity stores all the chain data.
2018-09-23 15:04:38  State DB configuration: fast
2018-09-23 15:04:38  Operating mode: active
2018-09-23 15:04:39  Configured for Foundation using Ethash engine
2018-09-23 15:04:40  Updated conversion rate to Ξ1 = US$245.42 (19403082 wei/gas)
2018-09-23 15:04:44  Public node URL: enode://623c9cce164ef340726f0163c83b3a472b7b8348d2bd2a509788f79ef74808d2803ad131c989b5d133ff72c6c256ef577b77b943d315fc119e4d9c967bf39a80@192.168.1.36:30303
```
As we can see, Parity connects by default to the ETH Mainnet, we can realize about it when we see the Dollar - ETH comparaison.

So we can add flags to the parity start command in order to modify it's behaviour, add functionalities, change it's running server ports etc..

Parity Ethereum supports a dev mode that is particularly useful for Dapp development and demos. Thanks to its Instant seal consensus engine, transactions are “mined” instantly. No need to wait for the next block.

To start it we run `$ parity --chain dev`.

```
2018-09-23 20:43:03  Starting Parity-Ethereum/v2.0.0-beta-6eae372-20180717/x86_64-linux-gnu/rustc1.27.1
2018-09-23 20:43:03  Keys path /home/kr0/.local/share/io.parity.ethereum/keys/DevelopmentChain
2018-09-23 20:43:03  DB path /home/kr0/.local/share/io.parity.ethereum/chains/DevelopmentChain/db/1484bce8c021f2ca
2018-09-23 20:43:03  State DB configuration: fast
2018-09-23 20:43:03  Operating mode: active
2018-09-23 20:43:04  Configured for DevelopmentChain using InstantSeal engine
2018-09-23 20:43:10  Public node URL: enode://623c9cce164ef340726f0163c83b3a472b7b8348d2bd2a509788f79ef74808d2803ad131c989b5d133ff72c6c256ef577b77b943d315fc119e4d9c967bf39a80@192.168.1.36:30303
2018-09-23 20:43:35     0/25 peers   9 KiB chain 79 KiB db 0 bytes queue 448 bytes sync  RPC:  0 conn,    0 req/s,    0 µs
```
We will talk later about the data displayed on the screen here.

## Customizing the development chain

The default configuration should work fine in most cases. However, it can be customised. The following example spec can be passed to the `--chain` option where accounts contains a custom account with lots of Ether.

**To make multiple transactions confirm at the same time** use `--reseal-min-period 0` and **to make transactions free** use `--gasprice 0`.

An address containing a lot of Ether (0x00a329c0648769a73afac7f9381e08fb43dbea72) has automatically added with a password being an empty string. This account has that many ether because it was given to
it on the genesis block: (This is the spec.json file of the DevelopmentChain)

```
{
    "name": "DevelopmentChain",
    "engine": {
        "instantSeal": null
    },
    "params": {
        "gasLimitBoundDivisor": "0x0400",
        "accountStartNonce": "0x0",
        "maximumExtraDataSize": "0x20",
        "minGasLimit": "0x1388",
        "networkID" : "0x11",
        "registrar" : "0x0000000000000000000000000000000000001337",
        "eip150Transition": "0x0",
        "eip160Transition": "0x0",
        "eip161abcTransition": "0x0",
        "eip161dTransition": "0x0",
        "eip155Transition": "0x0",
        "eip98Transition": "0x7fffffffffffff",
        "eip86Transition": "0x7fffffffffffff",
        "maxCodeSize": 24576,
        "maxCodeSizeTransition": "0x0",
        "eip140Transition": "0x0",
        "eip211Transition": "0x0",
        "eip214Transition": "0x0",
        "eip658Transition": "0x0",
        "wasmActivationTransition": "0x0"
    },
    "genesis": {  //Chain configuration parameters.
        "seal": {
            "generic": "0x0"
        },
        "difficulty": "0x20000",
        "author": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x7A1200"
    },
    "accounts": {
        "0000000000000000000000000000000000000001": { "balance": "1", "builtin": { "name": "ecrecover", "pricing": { "linear": { "base": 3000, "word": 0 } } } },
        "0000000000000000000000000000000000000002": { "balance": "1", "builtin": { "name": "sha256", "pricing": { "linear": { "base": 60, "word": 12 } } } },
        "0000000000000000000000000000000000000003": { "balance": "1", "builtin": { "name": "ripemd160", "pricing": { "linear": { "base": 600, "word": 120 } } } },
        "0000000000000000000000000000000000000004": { "balance": "1", "builtin": { "name": "identity", "pricing": { "linear": { "base": 15, "word": 3 } } } },
        "0000000000000000000000000000000000000005": { "balance": "1", "builtin": { "name": "modexp", "activate_at": 0, "pricing": { "modexp": { "divisor": 20 } } } },
        "0000000000000000000000000000000000000006": { "balance": "1", "builtin": { "name": "alt_bn128_add", "activate_at": 0, "pricing": { "linear": { "base": 500, "word": 0 } } } },
        "0000000000000000000000000000000000000007": { "balance": "1", "builtin": { "name": "alt_bn128_mul", "activate_at": 0, "pricing": { "linear": { "base": 40000, "word": 0 } } } },
        "0000000000000000000000000000000000000008": { "balance": "1", "builtin": { "name": "alt_bn128_pairing", "activate_at": 0, "pricing": { "alt_bn128_pairing": { "base": 100000, "pair": 80000 } } } },
        "0000000000000000000000000000000000001337": { "balance": "1", "constructor": "0x606060405233600060006101000a.........." }, //Pre compiled SmartContract
        "00a329c0648769a73afac7f9381e08fb43dbea72": { "balance": "1606938044258990275541962092341162602522202993782792835301376" } //Generic Development account with lots of ether.
    }
}
```

See the last line of the genesis file, where several accounts are created including our testing account with tones of ether on it.

This configuration is explained on the Parity Docs. And may provide a better understanding of which configurations are We aplying on our chain.


A JSON file which specifies rules of a blockchain, some fields are optional which are described following the minimal example, these default to 0.
```
{
	"name": "CHAIN_NAME",
	"engine": {
		"ENGINE_NAME": {
			"params": {
				ENGINE_PARAMETERS
			}
		}
	},
	"genesis": {
		"seal": {
			ENGINE_SPECIFIC_GENESIS_SEAL
		},
		"difficulty": "0x20000",
		"gasLimit": "0x2fefd8"
	},
	"params": {
			"networkID" : "0x2",
			"maximumExtraDataSize": "0x20",
			"minGasLimit": "0x1388"
	},
	"accounts": {
		GENESIS_ACCOUNTS
	}
}
```

-    "name" field contains any name used to identify the chain. It is used as a folder name for database files.
-    "engine" field describes the consensus engine used for a particular chain.
-    "genesis" contains the genesis block (first block in the chain) header information.
-    "seal" is consensus engine specific and is further described in Consensus Engines.
-    "difficulty" is the difficulty of the genesis block. This parameter is required for any type of chain but can be of arbitrary value if a PoA engine is used.
-     "gasLimit" is the gas limit of the genesis block. It affects the initial gas limit adjustment.
    Optional:
-        "author" address of the genesis block author.
-        "timestamp" UNIX timestamp of the genesis block.
-        "parentHash" hash of the genesis “parent” block.
-        "transactionsRoot" root of the genesis block’s transactions trie
-        "receiptsRoot" root of the genesis block’s receipts trie.
-        "stateRoot" genesis state root, calculated automatically from the "accounts" field.
-        "gasUsed" gas used in the genesis block.
-        "extraData" extra data of the genesis block.
    "params" contains general chain parameters:
-        "networkID" DevP2P supports multiple networks, and ID is used to uniquely identify each one which is used to connect to correct peers and to prevent transaction replay across chains.
-        "maximumExtraDataSize" determines how much extra data the block issuer can place in the block header.
-        "minGasLimit" gas limit can adjust across blocks, this parameter determines the absolute minimum it can reach.

      Optional:
    -        "accountStartNonce" in the past this was used for transaction replay protection
    -        "chainID" chain identifier, if not present then equal to networkID
    -        "subprotocolName" by default its the eth subprotocol
    -        "forkBlock" block number of the latest fork that should be checked
    -        "forkCanonHash" hash of the canonical block at forkBlock
    -        "bombDefuseTransition" block number at which the difficulty bomb (epsilon in Yellow Paper Eqs. 39, 44) is removed from the difficulty evolution
    -        "wasmActivationTransition" block number at which bytecode (in storage or transactions) can be run as Wasm bytecode and by WebAssembly VM.
**There are about 50 more optional params that may not enter in the scope of the course.**

    "accounts" contains optional contents of the genesis block, such as simple accounts with balances or contracts. Parity does not include the standard Ethereum builtin contracts by default. These are necessary when writing new contracts in Solidity since compiled Solidity often refers to them. To make the chain behave like the public Ethereum chain the 4 contracts need to be included in the spec file, as shown in the example below:
```
    "accounts": {
        "0x0000000000000000000000000000000000000001": { "balance": "1", "builtin": { "name":   "ecrecover", "pricing": { "linear": { "base": 3000, "word": 0 } } } },
        "0x0000000000000000000000000000000000000002": { "balance": "1", "builtin": { "name": "sha256", "pricing": { "linear": { "base": 60, "word": 12 } } } },
        "0x0000000000000000000000000000000000000003": { "balance": "1", "builtin": { "name": "ripemd160", "pricing": { "linear": { "base": 600, "word": 120 } } } },
        "0x0000000000000000000000000000000000000004": { "balance": "1", "builtin": { "name": "identity", "pricing": { "linear": { "base": 15, "word": 3 } } } }
    }
```
  Other types of accounts that can be specified:
- simple accounts with some balance "0x...": { "balance": "100000000000" }
- full account state "0x...": { "balance": "100000000000", "nonce": "0", "code": "0x...", "storage": { "0": "0x...", ... } }
- contract constructor, similar to sending a transaction with bytecode "0x...": { "balance": "100000000000", "constructor": "0x..." }. The constructor bytecode is executed
when the genesis is created and the code returned by the “constructor” is stored in the genesis state.


An important thing to mark here is that we can create a bunch of different tyoes of chains here just by changing some of the fields that we have on our `spec.json` in order
to get the type of chain we need.
An important example is that we can choose the consensus algorithm that we want to apply. Parity allows us to configure:
- Ethash (The original PoW engine)
- Instant Seal: The development chain consensus: Tx's are mined inmediately without the need of mining or waiting until the block is validated.
- Validator List: Archieves consensus by referring to a list of “validators” (referred to as authorities, when they are linked to physical entities). Validator set is a group of accounts which are allowed to participate in the consensus, they validate the transactions and blocks to later sign messages about them.

In the simplest case they can be specified at genesis using a simple "list" :
```
"validators": {
  "list": [
    "0x7d577a597b2742b498cb5cf0c26cdcd726d39e6e",
    "0x82a978b3f5962a5b0957d9ee9eef472ee55b42f1"
  ]
}
```
We can use SmartContracts in order to administrate the validator list and also, report missbehaviours of other validators.
- Aura

Simple and fast consensus algorithm, each validator gets an assigned time slot in which they can release a block. The time slots are determined by the system clock of each validator.
```
"engine": {
    "authorityRound": {
        "params": {
            "stepDuration": "5",
            "validators" : {
                "multi": {
                        "0": { "list": ["0xc6d9d2cd449a754c494264e1809c50e34d64562b"] },
                        "10": { "list": ["0xd6d9d2cd449a754c494264e1809c50e34d64562b"] },
                        "20": { "contract": "0xc6d9d2cd449a754c494264e1809c50e34d64562b" }
                }
            }
        }
    }
}
```
Here on Aura we can see that we can add Contracts as validators, as well as personal addresses.

## Interacting with the RPC Server.

So now let's assume we have our chain configured. What we should do now it's interact with the RPC Server by making RPC Requests to it.

To do it, we are going to start our dev chain: `$ parity --chain dev`

So now, we are gonna try to send a transaction from the development account (which passw is: "") to a random address (remember that they all exist because we are on an Account model, not an UTXO model)

To send a transaction we are gonna use the JSON RPC protocol (the way on which Parity server running on our machine can understand us)

### JSON RPC

JSON is a lightweight data-interchange format. It can represent numbers, strings, ordered sequences of values, and collections of name/value pairs.

JSON-RPC is a stateless, light-weight remote procedure call (RPC) protocol. Primarily this specification defines several data structures and the rules around their processing. It is transport agnostic in that the concepts can be used within the same process, over sockets, over HTTP, or in many various message passing environments. It uses JSON (RFC 4627) as data format.
**Transport**

- HTTP: Listens on port 8545
- WebSockets: Listens on port 8546
- IPC Socket: Listens on $BASE/jsonrpc.ipc (defaults to ~/.local/share/io.parity.ethereum/jsonrpc.ipc on Linux) //Default parity config path.

By default, the enabled JSON-RPC apis are: web3,eth,pubsub,net,parity,parity_pubsub,traces,rpc,secretstore.

By reviewing the JSON-RPC calls, we sse that to make the tx we need to:
```
curl --data '{"method":"personal_sendTransaction","params":[{"from":"0x00a329c0648769a73afac7f9381e08fb43dbea72","to":"0x14A1e6436D6B0b95CC2C174cAeaa6A275792010C",
"data":"0x00000000000000000000000000000000","value":"0x186a0"},""],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
```
- curl: shell command used to send requests to servers
- personal_sendTransaction: RPC Method that from the `personal` API.
- from: account from which the ether is being sent. (Note that is the dev account).
- to: account (random that I wrote) that would be the destinatary.
- data: Each tx can have data attached to it (contract function calls for example). On a regular ether tx, no data is needed.
- value: Hex representation of the ammount of ether passed to the reciever account (In Wei).
- "jsonrpc":"2.0": Specifies the version of the jsonrpc protocol used.
- "Content-Type: application/json": On every POST, GET, PUT etc... methods, you need to specify on the headings whitch is the format/type of data send. In our case it's application/json type.
- POST: Type of call.
- localhost:8545: Host where the call is done (Note that is the direction of our RPC Server)

So after executing it we get this:
`{"jsonrpc":"2.0","result":"0x0a0535af70856b0ceb3fa9da5354a1f3ef0def9b5ffea8104ba10d0785c49c5a","id":1}`
Where the tx Hash is returned to us.

We can now for example, check the recievers address balance.
To do it, we call:

```
curl --data '{"method":"eth_getBalance","params":["0x14A1e6436D6B0b95CC2C174cAeaa6A275792010C"],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
```
Where the addres sent on params is the reciever addres of the last tx we made.
We recieve the response: `{"jsonrpc":"2.0","result":"0x186a0","id":1}` Where we see that the balance is the same as the ether sent before.

We could also trace the RPC Requests and Responses by adding the flag: `--logging=rpc=trace`.
Then we can see all the traffic that goes to the server debbuged and the last calls done will look like:

For personal_sendTransaction:
```
2018-09-24 13:28:08   TRACE rpc  Request: {"method":"personal_sendTransaction","params":[{"from":"0x00a329c0648769a73afac7f9381e08fb43dbea72","to":"0x14A1e6436D6B0b95CC2C174cAeaa6A275792010C","data":"0x00000000000000000000000000000000","value":"0x186a0"},""],"id":1,"jsonrpc":"2.0"}. //Request arrived to the server
2018-09-24 13:28:09   INFO import  Imported #15 0x1bf8…662c (1 txs, 0.02 Mgas, 0 ms, 0.61 KiB) //Imported new tx to mine it.
2018-09-24 13:28:09  IO Worker #0 INFO own_tx  Transaction mined (hash 0x0a0535af70856b0ceb3fa9da5354a1f3ef0def9b5ffea8104ba10d0785c49c5a) //Tx gets mined and packed into the block with hash: 0x0a05...
2018-09-24 13:28:09   DEBUG rpc  [Some(Num(1))] Took 91ms //Time until Response is generated and sent
2018-09-24 13:28:09   DEBUG rpc  Response: {"jsonrpc":"2.0","result":"0x0a0535af70856b0ceb3fa9da5354a1f3ef0def9b5ffea8104ba10d0785c49c5a","id":1}. //Response
```
And like this for the eth_getBalance:
```
2018-09-24 13:32:58   TRACE rpc  Request: {"method":"eth_getBalance","params":["0x14A1e6436D6B0b95CC2C174cAeaa6A275792010C"],"id":1,"jsonrpc":"2.0"}.
2018-09-24 13:32:58   DEBUG rpc  Response: {"jsonrpc":"2.0","result":"0x186a0","id":1}.
```
## Work with our accounts.

So to import our account and deploy or make transactions with it on Parity, we have to import it.
We can do it in different ways:
- Putting our UTC file with the encrypted account parameters on `~/.local/share/io.parity.ethereum/keys/`.
- Importing it through JSON-RPC methods.

So first, we are going to check which accounts we have stored on our Parity Server.

`curl --data '{"method":"personal_listAccounts","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545`

Which returns to me all of the accounts I have stored on my Parity node:
```
{"jsonrpc":"2.0","result":["0x00a329c0648769a73afac7f9381e08fb43dbea72","0x47b7a2c38bd28038e2c3edf4e25560a04b5a8040"],"id":1}
```

### Import account ways

- From seed (If I have a HDW): `word rest ..... of ...... mnemonic forest`. We will use:  `parity_newAccountFromPhrase`
```
curl --data '{"method":"parity_newAccountFromPhrase","params":["word april clog enroll bunker double vintage diamond device pioneer arrest forest","<Password>"],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
```

- From SK:
`curl --data '{"method":"parity_newAccountFromSecret","params":["0x...secretkey...97F652","<Password>"],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545`

From Account: That is the command we need to import our account from a JSON UTC file (for example the UTC file of myetherwallet.com).
`curl --data '{"method":"parity_newAccountFromWallet","params":["{\"id\": \"9c62e86b-3cf9...\", ...}","<Password>"],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545`

**Its Important to notice here that the JSON file must be strigified, not on Raw JSON format.**

The three methods will output the same which is:
```
{
  "id": 1,
  "jsonrpc": "2.0",
  "result": "0x101ddd8087A971048F6580A1cfCE4F90C9d155BA"
}
```
So if we check our Listed accounts again:
`{"jsonrpc":"2.0","result":["0x00a329c0648769a73afac7f9381e08fb43dbea72","0x47b7a2c38bd28038e2c3edf4e25560a04b5a8040","0xa03da65c56f52c7bac4c01e3e80c43f4643a4d1c"],"id":1}`
Notice that one new account has appeared.
