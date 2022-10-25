import Foundation

public struct CrackStation: Decrypter {
    private var mappingToPlaintext: [String: String]
    
    enum CrackStationError: Error {
        case failedToLoadHashFromDisk(String)
        case invalidPasswordInput(String)
        // case hashNotFound(String) (not currently implemented)
    }

    /// When CrackStation is initailized, it will load the lookup table that maps hashed passwords to plaintext
    /// If it fails to load the data, it will intialize a blank dictionary and print the error message to the console.
    /// In conformity to Decrypter protocol, it does not throw an error.
    public init() {
        do {
            self.mappingToPlaintext = try CrackStation.loadDictionaryFromFile()
        } catch CrackStationError.failedToLoadHashFromDisk(let message) {
            self.mappingToPlaintext = [:]
            print("CrackStation instance could not find the necessary files in order to setup correctly.")
            print(message)
        } catch {
            self.mappingToPlaintext = [:]
            print("Unexpected error: \(error)")
        }
    }
    
    
    public static func loadDictionaryFromFile() throws -> [String: String] {
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
    public func decrypt(shaHash: String) -> String? {
        if shaHash.isEmpty {
            return nil
        }
        if let crackedPassword = self.mappingToPlaintext[shaHash] {
            return crackedPassword
        }
        else {
            return nil
        }
    }
}
    
