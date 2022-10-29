import XCTest
import CrackStation
import CryptoKit

final class CrackStationTests: XCTestCase {
    private let crackstation = CrackStation()
    
    func testLoadDictionary() {
        do {
            // Given
            let numAllowedChars = 26+26+10
            // one-character passwords + two-character passwords
            let expectedNumPermutations = (numAllowedChars) + numAllowedChars*numAllowedChars
            let arbitraryPassword = "y"
            let hashDigest = encryptUsingSha1(from: arbitraryPassword)
            // 26 lowercase letters + 26 uppercase + 10 digits
            
            
            // When
            let plaintextTable = try CrackStation.loadDictionaryFromFile()
            let crackedPassword = plaintextTable[hashDigest]
            
            // Then
            XCTAssertNotNil(plaintextTable)
            XCTAssertEqual(plaintextTable.count, expectedNumPermutations)
            XCTAssertEqual(crackedPassword, arbitraryPassword)
            
        } catch {
            XCTFail("unexpected error was thrown: \(error)")
        }
    }
    
    func testCanCrackAllOneCharacterPasswordsSHA1() {
        for char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" {
            // Given
            let password = String(char)
            let hashDigest = encryptUsingSha1(from: password)
            
            // When
            let crackedPassword = crackstation.decrypt(shaHash: hashDigest)
            
            // Then
            XCTAssertEqual(crackedPassword, password)
            
        }
    }
    
    func testCanCrackAllTwoCharacterPasswordsSHA1() throws {
        // Given
        for first_char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" {
            for second_char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" {
                // Given
                let password: String = String(first_char) + String(second_char)
                let hashDigest = encryptUsingSha1(from: password)
                
                // When
                let crackedPassword = crackstation.decrypt(shaHash: hashDigest)
                
                // Then
                XCTAssertEqual(crackedPassword, password)
            }
        }
        
    }
    
    func testUnabletoCrack() throws {
        // Given
        let password = "123"
        let hashDigest = encryptUsingSha1(from: password)
        
        // When
        let crackedPassword = crackstation.decrypt(shaHash: hashDigest)
        
        // Then
        XCTAssertNil(crackedPassword)
    }
    
    func testEmptyInput() throws {
        // Given
        let emptyShaHash = ""
        // When
        let crackedPassword = crackstation.decrypt(shaHash: emptyShaHash)
        // Then
        XCTAssertNil(crackedPassword)
    }
}




/// Helper function
func encryptUsingSha1(from input: String) -> String {
    let inputData = Data(input.utf8)
    let output = Insecure.SHA1.hash(data: inputData)
    return output.hexStr
}

/// Source - https://stackoverflow.com/a/57255962
/// Extension on CryptoKit.Digest that gives access to hexStr (the digest as a String)
extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data (bytes) }
    
    var hexStr: String {
        bytes.map { String(format:"%02x", $0) }.joined()
    }
}
