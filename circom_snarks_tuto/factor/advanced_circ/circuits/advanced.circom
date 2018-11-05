template Division() {
    signal private input a;
    signal private input b;
    signal output c;
    

    c <-- a/b;
    (a*b) - c === 0; 
}

component main = Division();