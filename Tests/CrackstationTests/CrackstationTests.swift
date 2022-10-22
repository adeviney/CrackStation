import XCTest
@testable import CrackStation

final class CrackStationTests: XCTestCase {
    
    func testCanCrack_oneChar_1() throws {
        let crackstation = try CrackStation()
        let crackedPassword = try crackstation!.crack("86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")
        XCTAssert(crackedPassword == "a")
        
    }
    
    func testCanCrack_oneChar_2() throws {
        let crackstation = try CrackStation()
        let crackedPassword = try crackstation!.crack("902ba3cda1883801594b6e1b452790cc53948fda")
        XCTAssert(crackedPassword == "7")
    }
}
