import XCTest
@testable import CrackStation
import CryptoKit

final class CrackStationTests: XCTestCase {
    private let myCrackstation = CrackStation()

    func testLoadDictionary() {
        do {
            // Given
            let numAllowedChars = 26+26+10+2

            let expectedNumPermutations =
                (numAllowedChars) +
                numAllowedChars*numAllowedChars +
                numAllowedChars*numAllowedChars*numAllowedChars

            let arbitraryPassword = "abc"

            let hashDigest = encryptUsingSha1(from: arbitraryPassword)

            // When
            let plaintextTable = try CrackStation.loadDictionaryFromFile()
            let crackedPassword = plaintextTable[hashDigest]

            // Then
            XCTAssertNotNil(plaintextTable)
            XCTAssertEqual(plaintextTable.count, expectedNumPermutations*2)
            XCTAssertEqual(crackedPassword, arbitraryPassword)

        } catch {
            XCTFail("unexpected error was thrown: \(error)")
        }
    }

    func testCanCrackAllOneCharacterPasswordsSHA1() {
        for char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?" {
            // Given
            let password = String(char)
            let hashDigest = encryptUsingSha1(from: password)

            // When
            let crackedPassword = myCrackstation.decrypt(shaHash: hashDigest)

            // Then
            XCTAssertEqual(crackedPassword, password)

        }
    }

    func testCanCrackAllOneCharacterPasswordsSHA256() {
        for char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?" {
            // Given
            let password = String(char)
            let hashDigest = encryptUsingSha256(from: password)

            // When
            let crackedPassword = myCrackstation.decrypt(shaHash: hashDigest)

            // Then
            XCTAssertEqual(crackedPassword, password)

        }
    }

    func testCanCrackAllTwoCharacterPasswordsSHA1() throws {
        // Given
        for firstChar in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?" {
            for secondChar in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?" {
                // Given
                let password: String = String(firstChar) + String(secondChar)
                let hashDigest = encryptUsingSha1(from: password)

                // When
                let crackedPassword = myCrackstation.decrypt(shaHash: hashDigest)

                // Then
                XCTAssertEqual(crackedPassword, password)
            }
        }
    }

    func testCanCrackAllTwoCharacterPasswordsSHA256() throws {
        // Given
        for firstChar in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?" {
            for secondChar in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?" {
                // Given
                let password: String = String(firstChar) + String(secondChar)
                let hashDigest = encryptUsingSha256(from: password)

                // When
                let crackedPassword = myCrackstation.decrypt(shaHash: hashDigest)

                // Then
                XCTAssertEqual(crackedPassword, password)
            }
        }
    }

    func testCanCrackAllThreeCharacterPasswordsSHA1() throws {
        // Given
        for charOne in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?!" {
            for charTwo in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?!" {
                for charThree in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?!" {
                    let password: String = String(charOne) + String(charTwo) + String(charThree)
                    let hashDigest = encryptUsingSha1(from: password)

                    // When
                    let crackedPassword = myCrackstation.decrypt(shaHash: hashDigest)

                    // Then
                    XCTAssertEqual(crackedPassword, password)
                }
            }
        }
    }

    func testCanCrackAllThreeCharacterPasswordsSHA256() throws {
        // Given
        for charOne in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?!" {
            for charTwo in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?!" {
                for charThree in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?!" {
                    let password: String = String(charOne) + String(charTwo) + String(charThree)
                    let hashDigest = encryptUsingSha256(from: password)

                    // When
                    let crackedPassword = myCrackstation.decrypt(shaHash: hashDigest)

                    // Then
                    XCTAssertEqual(crackedPassword, password)
                }
            }
        }
    }

    func testUnabletoCrack() throws {
        // Given
        let password = "1234"
        let hashDigest = encryptUsingSha1(from: password)

        // When
        let crackedPassword = myCrackstation.decrypt(shaHash: hashDigest)

        // Then
        XCTAssertNil(crackedPassword)
    }

    func testEmptyInput() throws {
        // Given
        let emptyShaHash = ""
        // When
        let crackedPassword = myCrackstation.decrypt(shaHash: emptyShaHash)
        // Then
        XCTAssertNil(crackedPassword)
    }
}

/// Helper function
/// Input: a string
/// Output: the string encrypted using the SHA-1 algorithm.
func encryptUsingSha1(from input: String) -> String {
    let inputData = Data(input.utf8)
    let output = Insecure.SHA1.hash(data: inputData)
    return output.hexStr
}

/// Input: a string
/// Output: the string encrypted using the SHA-256 algorithm.
func encryptUsingSha256(from input: String) -> String {
    let inputData = Data(input.utf8)
    let output = SHA256.hash(data: inputData)
    return output.hexStr
}

/// Source - https://stackoverflow.com/a/57255962
/// Extension on CryptoKit.Digest that gives access to hexStr (the digest as a String)
extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02x", $0) }.joined()
    }
}
