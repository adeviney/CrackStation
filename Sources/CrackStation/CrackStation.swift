import Foundation
import CryptoKit

public class CrackStation {
    private var mappingToPlaintext: [String: String]
    
    enum CrackStationError: Error {
        case failedToLoadHashFromDisk(String)
        // case hashNotFound(String) - not currently implemented
    }

    public init() throws {
        self.mappingToPlaintext = try CrackStation.loadDictionaryFromFile()
    }
    
    static func loadDictionaryFromFile() throws -> [String: String] {
        guard let filePath = Bundle.module.path(forResource: "HashtoPlaintextData", ofType: "json") else {
            throw CrackStationError.failedToLoadHashFromDisk("Could not find data resource in Bundle")
        }
        
        let jsonString = try String(contentsOfFile: filePath)
        let jsonData = Data(jsonString.utf8)
        
        
        if let dictionaryFromJson: [String: String] = try? JSONDecoder().decode(Dictionary<String, String>.self, from: jsonData) {
            return dictionaryFromJson
        } else {
            throw CrackStationError.failedToLoadHashFromDisk("Incorrect format for the data file. Make sure it is String-to-String mapping with valid JSON.")
        }
    }
    
    
    
    /// Either returns the cracked plain-text password
    /// or, if unable to crack, then returns nil.
    public func crack(_ password: String) -> String? {
        if let crackedPassword = self.mappingToPlaintext[password] {
            return crackedPassword
        }
        else {
            return nil
        }
    }
}
    
