import XCTest
import CrackStation

final class CrackStationTests: XCTestCase {
    
    func testLoadDictionary() throws {
        do {
            // When
            let plaintextTable = try CrackStation.loadDictionaryFromFile()
            // Then
            XCTAssertNotNil(plaintextTable)
            
            
            // When
            let crackedpassword = plaintextTable["95cb0bfd2977c761298d9624e4b4d4c72a39974a"]
            // Then
            XCTAssert(crackedpassword == "y")
        } catch {
            XCTFail("unexpected error was thrown: \(error)")
        }
    }
    
    func testCanCrack_oneChar_1() throws {
        // Given
        let crackstation = CrackStation()
        // When
        let crackedPassword = crackstation.decrypt(shaHash: "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")
        // Then
        XCTAssert(crackedPassword == "a")
    }
    
    func testCanCrack_oneChar_2() throws {
        // Given
        let crackstation = CrackStation()
        // When
        let crackedPassword = crackstation.decrypt(shaHash: "902ba3cda1883801594b6e1b452790cc53948fda")
        // Then
        XCTAssert(crackedPassword == "7")
    }
    
    func testUnabletoCrack() throws {
        // Given
        let crackstation = CrackStation()
        // When
        let crackedPassword = crackstation.decrypt(shaHash: "c48ee8a8448ed522eaf905a16361bdd816ededae")
        // Then
        XCTAssertNil(crackedPassword)
    }
    
    func testEmptyInput() throws {
        // Given
        let crackstation = CrackStation()
        // When
        let crackedPassword = crackstation.decrypt(shaHash: "")
        // Then
        XCTAssertNil(crackedPassword)
        
    }
}
