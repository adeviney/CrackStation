# CrackStation

## Introduction
This is library used to "crack" an encrypted string; that is, it will reveal the original plaintext that was encrypted using a hashing function. The most obvious use case is cracking passwords.

As of POCv1, the library has the capability to crack any single-character password of any upper or lower case English alphabet letter or 10 Arabic digits, encrypted using the SHA-1 hash function. Future developments will unveil the ability to crack a SHA-2 encrypted password that is up to 3 characters in length and contains letters, numbers, and special characters. Improvements beyond this are easy to imagine, but not guaranteed.

## How to Use The CrackStation
Before you begin, make sure you have added the CrackStation package as a dependency in your project and `import CrackStation` is included as a header in your project.

### Instantiating
First, create an instance of CrackStation. Because the initialization can throw an error in rare cases, make sure you use the `try` keyword.

``` Swift
let crackstation = try CrackStation()
```

### Using the `crack` method
Use the CrackStation instance you defined earlier. Pass the encrypted string you wish to crack as an argument in the CrackStation's crack method. You must again use the `try` keyword to handle an error if it is thrown.

``` Swift
let encryptedPassword = "ac3478d69a3c81fa62e60f5c3696165a4e5e6ac4"
let plaintextPassword = try crackstation.crack(encryptedPassword)
print(encryptedPassword as Any)
// 5
```
