import Foundation
import CryptoKit

public class Crackstation {
    private var mappingToPlaintext: [String: String]
    
    enum CrackStationError: Error {
        case failedToLoadHashFromDisk(String)
        case hashNotFound(String)
    }

    public init?() throws {
        guard let path = Bundle.module.url(forResource: "HashtoPlaintextData", withExtension: "json") else {
            throw CrackStationError.failedToLoadHashFromDisk("Could not find data resource in Bundle")
        }
        
        let data = try Data(contentsOf: path)
        let jsonResult = try JSONSerialization.jsonObject(with: data)
        
        if let lookupTable: Dictionary = jsonResult as? Dictionary<String, String> {
            self.mappingToPlaintext = lookupTable
        } else {
            throw CrackStationError.failedToLoadHashFromDisk("Incorrect format for the data file. Make sure it is valid JSON.")
        }
    }
    
    /// Either returns the cracked plain-text password
    /// or, if unable to crack, then returns nil.
    ///
    /// Throw an error if <insert explanation here>.
    public func crack(_ password: String) throws -> String? {
        if let crackedPassword = self.mappingToPlaintext[password] {
            return crackedPassword
        }
        else {
            throw CrackStationError.hashNotFound("\(password) could not be cracked")
        }
    }
}
    
