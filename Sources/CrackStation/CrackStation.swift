import Foundation

public class CrackStation {
    private var mappingToPlaintext: [String: String]
    
    enum CrackStationError: Error {
        case failedToLoadHashFromDisk(String)
        case invalidPasswordInput(String)
        // case hashNotFound(String) (not currently implemented)
    }

    /// When CrackStation is initailized, it will attempt to load the look-up table from the file
    /// If it is unable to load the dictionary, it will throw a `failedToLoadHashFromDisk` error
    public init() throws {
            self.mappingToPlaintext = try CrackStation.loadDictionaryFromFile()
    }
    
    
    static func loadDictionaryFromFile() throws -> [String: String] {
        guard let filePath = Bundle.module.path(forResource: "HashtoPlaintextData", ofType: "json") else {
            throw CrackStationError.failedToLoadHashFromDisk("Could not find data resource in Bundle. Be sure that the dependency Crackstation/Sources/Resources/HashtoPlaintextData.json exists.")
        }
        
        let jsonString = try String(contentsOfFile: filePath)
        let jsonData = Data(jsonString.utf8)
        if let dictionaryFromJson: [String: String] = try? JSONDecoder().decode(Dictionary<String, String>.self, from: jsonData) {
            return dictionaryFromJson
        } else {
            throw CrackStationError.failedToLoadHashFromDisk("Incorrect format for the data file. Make sure it is a String-to-String mapping with valid JSON.")
        }
    }
    
    
    
    /// Either returns the cracked plain-text password
    /// or, if unable to crack, then returns nil.
    ///
    /// Throws an error if the password is empty
    public func crack(_ password: String) throws -> String? {
        if password.isEmpty {
            throw CrackStationError.invalidPasswordInput("Your password is empty")
        }
        if let crackedPassword = self.mappingToPlaintext[password] {
            return crackedPassword
        }
        else {
            return nil
        }
    }
}
    
