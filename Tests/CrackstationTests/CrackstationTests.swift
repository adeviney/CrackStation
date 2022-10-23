import XCTest
@testable import CrackStation

final class CrackStationTests: XCTestCase {
    
    func testLoadDictionary() throws {
        do {
            let plaintextTable = try CrackStation.loadDictionaryFromFile()
            XCTAssertNotNil(plaintextTable)
            
            let crackedpassword = plaintextTable["95cb0bfd2977c761298d9624e4b4d4c72a39974a"]
            XCTAssert(crackedpassword == "y")
        } catch {
            XCTFail()
        }
        
    }
    func testCanCrack_oneChar_1() throws {
        let crackstation = try CrackStation()
        let crackedPassword = crackstation.crack("86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")
        XCTAssert(crackedPassword == "a")
        
    }
    
    func testCanCrack_oneChar_2() throws {
        let crackstation = try CrackStation()
        let crackedPassword = crackstation.crack("902ba3cda1883801594b6e1b452790cc53948fda")
        XCTAssert(crackedPassword == "7")
    }
    
    func testUnabletoCrack() throws {
        let crackstation = try CrackStation()
        let crackedPassword = crackstation.crack("c48ee8a8448ed522eaf905a16361bdd816ededae")
        XCTAssertNil(crackedPassword)
    }
}
