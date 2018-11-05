# Iden3's Circom Snarks

- [x] Circom basic tutorial.
- [ ] Advanced Circuits and non mathematical problems prooving.
- [ ] Solidity integration of the second part.

This just is a collection of notes and explanations that I'll be taking while doing the tuto and further explorations i'll realize by myself.

> Required: Node.js >=8.12.0 but recommended: 10.12.0 (Big Intger native libraries included!!). `snarkjs` will take profit of it (if possible).

## Installation: 
```
$ npm install -g circom
$ npm install -g snarkjs
```

## Circuit creation

We create a circuit directory `factor`. (Recommended to have a circuits folder with a git repo in it with it's tests and codes.)

We create a new ciruit file: `$ touch testcirc.circom` with the content:
```java
template Multiplier() {
    signal private input a;
    signal private imput b;
    signal output c;

    c <== a*b;
}

component main = Multiplier();
```
This circuit forces the signal `c` to be the value `a*b`.
Note that we instantiated the Multiplier template with a component named `main` **which mus always exist**.

## Circuit compiling

To compile our circuit to a .json file (which snarkjs library will understand and be able to use) we run the following:
> `$ circom testcirc.circom -o testcirc.json`

That creates us the `testcirc.json` file that we will use later.

## Snarkjs enters in action.
First we see that the file has the following format:
```json
{
 "mainCode": "{\n}\n",
 "signalName2Idx": {
  "one": 0,
  "main.a": 2,
  "main.b": 3,
  "main.c": 1
 },
 "components": [
  {
   "name": "main",
   "params": {},
   "template": "Multiplier",
   "inputSignals": 2
  }
 ],
 "componentName2Idx": {
  "main": 0
 },
 "signals": [
  {
   "names": [
    "one"
   ],
   "triggerComponents": []
  },
  {
   "names": [
    "main.c"
   ],
   "triggerComponents": []
  },
  {
   "names": [
    "main.a"
   ],
   "triggerComponents": [
    0
   ]
  },
  {
   "names": [
    "main.b"
   ],
   "triggerComponents": [
    0
   ]
  }
 ],
 "constraints": [
  [
   {
    "2": "21888242871839275222246405745257275088548364400416034343698204186575808495616"
   },
   {
    "3": "1"
   },
   {
    "1": "21888242871839275222246405745257275088548364400416034343698204186575808495616"
   }
  ]
 ],
 "templates": {
     //Here we see the Multiplier template code on an snarkjs readable version. 
  "Multiplier": "function(ctx) {\n    ctx.setSignal(\"c\", [], bigInt(ctx.getSignal(\"a\", [])).mul(bigInt(ctx.getSignal(\"b\", []))).mod(__P__));\n    ctx.assert(ctx.getSignal(\"c\", []), bigInt(ctx.getSignal(\"a\", [])).mul(bigInt(ctx.getSignal(\"b\", []))).mod(__P__));\n}\n"
 },
 "functions": {},
 "nPrvInputs": 2,
 "nPubInputs": 0,
 "nInputs": 2,
 "nOutputs": 1,
 "nVars": 4,
 "nConstants": 0,
 "nSignals": 4
}
```
### Circuit info and details.
Now that we have a circuit we can do a few things with snarkjs library:
- See our circuit constraints:
To do it we execute: `$ snarkjs printconstraints -c testcirc.json`. Which gives us something that we were expecting: `[  -1main.a ] * [  1main.b ] - [  -1main.c ] = 0`. 
**This output makes sense, if you think it it's easy to see that the result of the product less `c` (which is also the result) must be zero.**

We can see addition info of the circuit by executing: `$ snarkjs info -c testcirc.json`. Which returns in this case:
```
# Wires: 4
# Constraints: 1 //Conditions that the circuit must satisfy
# Private Inputs: 2 
# Public Inputs: 0
# Outputs: 1
```
### Setting up using Snarkjs

To run a setup for the circuit we execute: `$ snarkjs setup -c <circuit_name.json>`. By default snarkjs library will use `circuit.json` if no circuit is specified.

The output of the command consists on the files: `verification_key.json` and `proving_key.json` **which I guess are the mathematical implementation of the circuit.**

### Calculating a witness

Before creating any proof, we need to verify that all the signals of the circuit match (all) the constraints of the ciircuit. **The set of signals is the witness.**

The ZKPs prove that you know a set of signals that matches all the constraints, **but without revealing any info about the signals except the public inputs and the outputs**.

`snarkjs` does the set of signals calculations for you. This will provide a file with the inputs and it will execute the circuit and calculate all the intermediate signals and the output.

##### Example: Factorisation of a number.
Let's supose you want to proove that yopu are able to factorize the number `33`. This means you know two numbers `a` and `b` that multiplied produce `33`.

We create a file with our input parameters named `input.json`
```json
{
    "a": 3,
    "b": 11
}
```

To calculate the witness we run `snarkjs calculatewitness -c testcirc.json`. Note that a new json file was generated with the name: `witness.json`. Which looks like this:
```json
[
 "1",
 "33",
 "3",
 "11"
]
```
Here we see all of the different signals of the circuit.

#### Create the proof
With the witness generated, we can now generate the proof by doing: `$ snarkjs proof`. This command uses `witness.json` and `prooving_key.json` to generate:

`proof.json` and `public.json`.
- proof file contains the raw data of the proof that the snarkjs library will use to verify that we know a witness that satisfies the circuit. It looks like this:
```json
{
 "pi_a": [
  "19826736229496222914042957678676594646487928122809399344451854669658145297527",
  "2634984150875680490731151134374359844165630383050972908781761501172097420735",
  "1"
 ],
 "pi_ap": [
  "92895479573012556600932969664308229653935804142413397702004120022414927204",
  "1779620150361906910110460988578972693900805781469708425011408762445221189889",
  "1"
 ],
 "pi_b": [
  [
   "16927077732489738233891595168559740939960496392019715626893332163184676355311",
   "11323284128121574977583259031278198532612576917629801620103447679888763676966"
  ],
  [
   "1654683027262619127077634345683777292633223698120493896092963716834333293945",
   "11108774617545981579109558837407852757944530472416298546150783461042753191779"
  ],
  [
   "1",
   "0"
  ]
 ],
 "pi_bp": [
  "17629721890932770908184259251377277252613687558548583022523210055981675534667",
  "2654588245480869614540863238811026589319881844578382976033182497030914965504",
  "1"
 ],
 "pi_c": [
  "10308179063836193125026826210094137749162110856935110857103252987353130364165",
  "2876977005527167505309245471352805528543203336543896748733677167100293373430",
  "1"
 ],
 "pi_cp": [
  "11950591033183336717348600982685397560783978128279198935562495439782845381324",
  "5235256809568608503991240154577700307157380271407597176658238302141362315306",
  "1"
 ],
 "pi_kp": [
  "3011776433475757372593584812166575852982468118275873400797719951885552613962",
  "5728131238303583563651227369764162877314910585841243338490732830382223457911",
  "1"
 ],
 "pi_h": [
  "13641719963056706197187435380951201677761584267380849353742989718407609585147",
  "14269233575643403945165960538299535584139779327185949730797498266996787509003",
  "1"
 ]
}
```
![](https://www.boastingbiz.com/wp-content/uploads/Readability1-300x296.png)

- public file contains all of the input signals of the circuit. Looks like this for our example:
```
[
 "33" //Just the output of the product is public.
]
```
---------------------------------------------------------------------

**Now we've calculated the proof. What this means is that our inputs are going to be "hided" by some methodology.** Homomorphic hiding is a great example of that kind of hidings. [Here](https://z.cash/blog/snark-explain/) you got an interesting short lecture on ZCash blog that I rode some months ago.

This will make able us to verify the proof without revealing which were our inputs as we will se now:

#### Verifying the proof

To verify the proof we will run `$ snarkjs verify` which will print `Ok` if the verification is correct (the validation is satisfied as a result of the pairing operation that has been done) or `INVALID` otherwise.

The command will use `verification_key.json` and `proof.json` and `public.json` **(but notice that won't use any private signal that we used as input!!! (On a human readable form I mean)). It will use our inputs hided as large numbers which give no information about our witness!!**

#### Generating a Solidity verifier

Now that we can verify proofs, the main threat is to do this proces on-chain. To do this We start by generating a verifier.sol file. 

Run `$ snarkjs generateverifier`. We get as a result a `verifier.sol` file with all the math requirements (ECDSA implementation (Starting from the Finite fields generators), Pairings integration on Solidity) to achieve the proof verification running only using solidity code.

The contract looks like this:
```javascript
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
pragma solidity ^0.4.14;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point) {
        // Original code point
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );

/*
        // Changed by Jordi point
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
*/
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point p) pure internal returns (G1Point) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return the sum of two points of G1
    function addition(G1Point p1, G1Point p2) view internal returns (G1Point r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := staticcall(sub(gas, 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }
    /// @return the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point p, uint s) view internal returns (G1Point r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := staticcall(sub(gas, 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] p1, G2Point[] p2) view internal returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := staticcall(sub(gas, 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point a1, G2Point a2, G1Point b1, G2Point b2) view internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2
    ) view internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2,
            G1Point d1, G2Point d2
    ) view internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}
contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G2Point A;
        Pairing.G1Point B;
        Pairing.G2Point C;
        Pairing.G2Point gamma;
        Pairing.G1Point gammaBeta1;
        Pairing.G2Point gammaBeta2;
        Pairing.G2Point Z;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G1Point A_p;
        Pairing.G2Point B;
        Pairing.G1Point B_p;
        Pairing.G1Point C;
        Pairing.G1Point C_p;
        Pairing.G1Point K;
        Pairing.G1Point H;
    }
    function verifyingKey() pure internal returns (VerifyingKey vk) {
        vk.A = Pairing.G2Point([5532281056558036106255678173344179295920652269958682960957871454628416512972,10411498060575679769923504775586050525498200056812986338934849374272022274779], [21488499097666296663868390037499088809395779661820405221122053850058531732731,12572455853163705027429248203463324054648029865573171998494730725420526021169]);
        vk.B = Pairing.G1Point(19425079648490373375312886165806532347592567187862210486978769759663407702174,17414920549417306278774693485671073911213266585921030138156963972230146845925);
        vk.C = Pairing.G2Point([21650211314446716881038693063327713621054485913025016654891174718830382503557,8892278926044411392471106002749381041256123933177242461418108562469481473432], [4228134132323091167036805154928859913899970568850172648302687303185439128875,16505963817807084541674073771889870606460159226145197809640671338243272179549]);
        vk.gamma = Pairing.G2Point([10908277312711497904822412671300023952050081149828518650656015172439183467891,4468588423682801867940866501149064230735032403436877798957042119849255823933], [20096650009411433041348571059551783703917251559483402913787676465951465817787,18840171767261365426627542630901771911514607234064144424594493545084435964037]);
        vk.gammaBeta1 = Pairing.G1Point(4260572808250611024035155800950849907720222459007825421553825006806293706820,12166577651314726037856057410959763395953561241872965676490888927372548208948);
        vk.gammaBeta2 = Pairing.G2Point([2233710531193523302501392775014331506083935680060677860590366344758094332009,10648442187774304780596717718280127682214064507803658994155136610805673265293], [3112945447904896878263016101290725984364885544419203795515619002094736141542,7346201101221568385830817617456169715243934848407024000413614502058676992373]);
        vk.Z = Pairing.G2Point([19762629955607072687245684101309898449802236329755965527039087379607429843969,4463701001401227936313081136754638281090530510528159764727914298646799261241], [9954743696359184165273337385575294498048110871513373771298595253707446998041,13775261453374196526073458159454744231541436954605313348588374162639647627291]);
        vk.IC = new Pairing.G1Point[](2);
        vk.IC[0] = Pairing.G1Point(4297464036875307739554600242639379123297216512802130961340557995258056588542,11337040384827235166073050215777435443360101503712710421184364595276066550421);
        vk.IC[1] = Pairing.G1Point(14237922096242266636450415991812377963392883475988475187883289629291936048187,18915987043793562814827151220188367665669941896276990698227568966701728464676);

    }
    function verify(uint[] input, Proof proof) view internal returns (uint) {
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++)
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd2(proof.A, vk.A, Pairing.negate(proof.A_p), Pairing.P2())) return 1;
        if (!Pairing.pairingProd2(vk.B, proof.B, Pairing.negate(proof.B_p), Pairing.P2())) return 2;
        if (!Pairing.pairingProd2(proof.C, vk.C, Pairing.negate(proof.C_p), Pairing.P2())) return 3;
        if (!Pairing.pairingProd3(
            proof.K, vk.gamma,
            Pairing.negate(Pairing.addition(vk_x, Pairing.addition(proof.A, proof.C))), vk.gammaBeta2,
            Pairing.negate(vk.gammaBeta1), proof.B
        )) return 4;
        if (!Pairing.pairingProd3(
                Pairing.addition(vk_x, proof.A), proof.B,
                Pairing.negate(proof.H), vk.Z,
                Pairing.negate(proof.C), Pairing.P2()
        )) return 5;
        return 0;
    }
    function verifyProof(
            uint[2] a,
            uint[2] a_p,
            uint[2][2] b,
            uint[2] b_p,
            uint[2] c,
            uint[2] c_p,
            uint[2] h,
            uint[2] k,
            uint[1] input
        ) view public returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.A_p = Pairing.G1Point(a_p[0], a_p[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.B_p = Pairing.G1Point(b_p[0], b_p[1]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        proof.C_p = Pairing.G1Point(c_p[0], c_p[1]);
        proof.H = Pairing.G1Point(h[0], h[1]);
        proof.K = Pairing.G1Point(k[0], k[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}
```
So basically here we have implemented the Verifying proccedure on a Solidity contract that uses a Pairing Library to be able to evaluate a Pairing operation that we must satisfy at the final of the Snark verification process.

### Verifying the proof on-chain
The verifier contract we see up here, has a `view` function called `verifyProof` that without wasting gas (as is view and does not modify the state of the chain even seeing that runs code) lets us to verify our proofs. 
This functio will return `true` if the proof and the inputs are valid.

To get a shortcut to the call construction, `snarkjs` library provides us with the following feature: `$ snarkjs generatecall` wich will give us an outpit like:
```json
["0x2bd588f7b47dd844e7ffb8b2d40e247d324d26e8454a8e7ada1d3913413a1477", "0x05d3592231a4b4bcb657ff0aaec0e9eced383f6aa0c88b78eebd6eb5b27d0dbf"],["0x003493b4d78f75798fceec17feabf59732abb8c22027120768e5fe4f27da2564", "0x03ef3ab4137b10e43829e50095539102fe8f95912a0647835bb1a61b8dd9d901"],[["0x1908c06f5710a9dcc21d318b8be7b7def7a389c81c4fdce2bf274bfe34946926", "0x256c62f06299354a00d9e7d7381fc715b2457c94e1958b47f7bc18f9442cbcef"],["0x188f57f76148e679bb9f98bad51dfb53c0d753cf45cad2b3e34eaca42c813f63", "0x03a884749f219049dfd3aa99313aa8c181bc87899e7695549bef499a7b6ffd79"]],["0x26fa11a8ba41b4fea6003d7e105b7f9b40d5b115f27688a7dd66e81d4cc3594b", "0x05de71967a0fad7295fc17ed17f0156e803a2455a133f5a61063aedd90240000"],["0x16ca38fbdc1453188dd6c707858eaaad8198773bb74d808dbe909b1768dc6d05", "0x065c4fb00af9f42be11353e54c35d3f849d22b2278da3af8dbff1aa62f655df6"],["0x1a6bcb79a5764311dbbc307bd125c979eba64d0041fa1f8fafb95d607a007acc", "0x0b930ce395b582d93fcf4e2c5c5c1c8da9d18baa6b7994238b2dcd754f25a02a"],["0x1e28f09bede3893adfbeead564f1483c57aa2984c7bdbf40247821e118b40dfb", "0x1f8c199971979f0068f7bb968b51fa81750ed0582ed67becfc85dafdc665f70b"],["0x06a89ae4b726e1dd23aab88df18e5dc13a8a654369652d0b4027b051a7107a4a", "0x0caa01e435ea261451e4456ba3d811d9ec8eebdf02d317d1dca2fa1624b2fe77"],["0x0000000000000000000000000000000000000000000000000000000000000021"]
```
This is our proof, that comes from our witness as we can easily check:

1. We edit the `input.json` file:
```json
{
    "a": 1,
    "b": 33
}
```
2. Calculate the witness to be able to generate the proof.
`$ snarkjs calculatewitness -c testcirc.json` 

3.  Generate the proof and verify it by doing:

`$ snarkjs proof` and then `$ snarkjs verify` obtaining `true` because 1 and 33 factor 33 too!
Note that the first command gives us a different proof than before because our witness (inputs) has changed.

4. We generate the call and analyze de results with for example, `meld`:

`$ snarkjs generatecall` gives us now: 
```json
["0x0087207596fa50d37f2c1057720a5ce4029945b042b0cbd4c0da6e55f94115a5", "0x2c9a9c92306a5386997498013e891dddb52deb0b9337270c933bf7ce9a6bd72d"],["0x1422858151dc06f163c06fcc7085ce8dbca8bd3aec441d9f87700cb7e2b0fcc0", "0x08487c40b704f43f81b4fdc85f0e66dd8dbed18b1c7b3240f161234718311b82"],[["0x13b8742ee1c6d83a696e59586f264a9f621c5aaa109acdc9746bb5f7abe5f022", "0x247dcd3aca10af834365131b6e3a0e3cc7b791f2fc66807b344f4bed613fe741"],["0x21b94045e125576840394ba41c6936b58cdac75f8b5e8d0c20630815ae9b7153", "0x1a9086f3a732c76e95a8ce0a68e05ac852ae6ce19e588ff0a15af2215e47488c"]],["0x2196796403dd3f69f6485bcf944ea6ecd03e783ec33d992c580f3d44523354be", "0x148ee40dc32963a28353de972405e30ad782ec978099afc970a9a5e992372dc7"],["0x102e33fcdd9c8aaaa210abaf4a3e088b8fa82387d3196c6623e8adab90174f14", "0x145053859f39c7079c652d9d25204633a9ad722682fe659e239577fe9ac577a9"],["0x05ce2f6fa1d38f994fe13c728303de00603a8dc2df14e6390f62f998b28696a7", "0x2fe89559780fe60713194f57e9f5ff1a8297622f8746549397e55e33d582add0"],["0x0877803d4fb224c33a07f1b5cc672cf7e67c4d6c879d4ab839394951cbed3f60", "0x18290394536131098d4dd415f9c414c09fca1300b4c8ad8de2a90d9e2181f217"],["0x18ed5b6859972444763a45a3f6429cfd561dfdadeb8e876ee2a5809f8df81c67", "0x17e3ff85f31d9d8820aa28bf24098b0aa61214ffabc3ca0e500f59c34e006990"],["0x0000000000000000000000000000000000000000000000000000000000000021"]
```
**Whick means that our witness changes produced proof changes and then call changes were obviously produced too (as we expected) but both of the proofs were verified successfully!!**


## More complex circuits.

Before starting with more complex circuits, we will explain better the syntax used on `.circom` circuits.

### Operators.
- `<== , ==>`: These two operators are used to **connect signals and at the same time impose a constraint**.
- `<-- , -->`: These two operators assign values to siganls but don't generate any constraints. Generally these operators are used to do make divisions or mod operations. 
**Generally they always go together with an `===` operator to force a constraint:**
Here I made a very easy example:
```java
template Division() {
    signal private input a;
    signal private input b;
    signal output c;
    
    c <-- a/b; //Assigns no constraint, just the value of the division.
    (a*b) - c === 0; //Note that the constraint must be added with the modulus operation like we are doing here!
}

component main = Division();
```