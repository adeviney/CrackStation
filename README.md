# CrackStation

## Author
[Alexis Deviney](https://github.com/adeviney)

## Introduction
The CrackStation library can be used in your Swift projects to "crack" a hash digest (if it falls within a limited set of hashes, see below). That is, it will reveal the original plaintext that was hashed with the SHA-1 algorithm (and in future versions, SHA-2). 

The most obvious use case is cracking passwords. You may want to use this library to test the strength and "crackability" of your password, or, if you wish, to obtain fradulent credentials. Or - you may have other plans for the CrackStation, such as forcing an early reveal of your friend's hashed rock-paper-scissors choice, to secure your own winning move. The CrackStation library makes no moral judgements.

## Included Hashes
As of version 1.1.0, CrackStation has the capacity to crack any SHA-1-encrypted 1-2 character password that contains any upper or lower case English alphabet letter or any Arabic numeric digit (0-9) -- or, if you are RegEx inclined, any password that matches [A-Za-z0-9{1,2}].

With future developments, the library will be able to crack a SHA-1 or SHA-2 encrypted password that is up to 3 characters in length and may contain letters, numbers, and special characters. See [the below note](#Note) for a discussion about this.

## How to Use The CrackStation

### Instantiating
First, create an instance of the CrackStation object.

``` Swift
let crackstation = CrackStation()
```

### Using the `decrypt` method
Use the CrackStation instance you defined earlier. Pass a hashed string as an argument in the CrackStation's decrypt method.

``` Swift
let encryptedPassword = "ac3478d69a3c81fa62e60f5c3696165a4e5e6ac4"
let plaintextPassword = crackstation.decrypt(encryptedPassword)
print(plaintextPassword as Any)
// 5
```

#### 
If the hash you passed is not known to CrackStation, it will return `nil`.


## Troubleshooting
If the CrackStation is unable to set up correctly, it will print error messages to the console. Check the console if CrackStation is not able to crack passwords you'd expect it to. 

Please report any issues [here](https://github.com/adeviney/Fall22-CS561-CrackStation/issues).

## Note
Further improvements are needed to make this library practical (who uses a 3-character password!). In order to be feasible, a different strategy will need to be adopted. The current strategy is to save all possible hashes of all possible combinations of characters. Using this strategy, at even just 5 characters, over a billion permutations would need to be saved in the look-up table. Instead, hashes should only be stored for the most likely permutations. Combinations of dictionary words with additions of numbers or special characters is a good place to start.
