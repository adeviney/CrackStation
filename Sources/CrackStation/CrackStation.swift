import Foundation
import CryptoKit

public class CrackStation {
    private var mappingToPlaintext: [String: String]
    
    enum CrackStationError: Error {
        case failedToLoadHashFromDisk(String)
        case hashNotFound(String)
    }

    public init?() throws {
        guard let filePath = Bundle.module.path(forResource: "HashtoPlaintextData", ofType: "json") else {
            throw CrackStationError.failedToLoadHashFromDisk("Could not find data resource in Bundle")
        }
        
        let jsonString = try String(contentsOfFile: filePath)
        let jsonData = Data(jsonString.utf8)
        
        
        if let dictionaryFromJson: [String: String] = try? JSONDecoder().decode(Dictionary<String, String>.self, from: jsonData) {
            self.mappingToPlaintext = dictionaryFromJson
        } else {
            throw CrackStationError.failedToLoadHashFromDisk("Incorrect format for the data file. Make sure it is String-to-String mapping with valid JSON.")
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
    
