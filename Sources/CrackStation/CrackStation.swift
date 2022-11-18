import Foundation

public struct CrackStation: Decrypter {
    /// lookup Table. Maps hashed digest to plaintext.
    private let mappingToPlaintext: [String: String]

    /// Custom CrackStation Errors thrown internally when initialization fails unexpectedly
    enum CrackStationError: Error {
        case failedToLoadHashFromDisk(String)
        case invalidPasswordInput(String)
    }

    /// When CrackStation is initailized, it will load the lookup table that maps hashed passwords to plaintext
    /// If it fails to load the data, it will intialize a blank dictionary and print the error message to the console.
    /// In compliance with the Decrypter protocol, it does not throw an error to the caller.
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

    /// Returns lookup table as a dictionary.
    /// Data is read from file "HashtoPlaintextDataMVP.json" which is expected to be in the Resources folder.
    /// If unable to find the file, throws failedToLoadHashFromDisk error
    /// If unable to parse JSON into a dictionary [String:String], throws failedToLoadHashFromDisk error
    static func loadDictionaryFromFile() throws -> [String: String] {
        guard let filePath = Bundle.module.path(forResource: "HashtoPlaintextDataMVP", ofType: "json") else {
            throw CrackStationError.failedToLoadHashFromDisk("""
            Could not find data resource in Bundle. Be sure that the dependency
            Crackstation/Sources/Resources/HashtoPlaintextDataMVP.json exists.
            """)
        }

        let jsonString = try String(contentsOfFile: filePath)
        let jsonData = Data(jsonString.utf8)
        if let dictionaryFromJson: [String: String] =
            try? JSONDecoder().decode(Dictionary<String, String>.self,
                                      from: jsonData) {
            return dictionaryFromJson
        } else {
            throw CrackStationError.failedToLoadHashFromDisk("""
            Incorrect format for the data file.
            Make sure it is a String-to-String mapping with valid JSON.
            """)
        }
    }

    /// Either returns the cracked plain-text password
    /// or, if unable to crack, then returns nil.
    /// Able to crack any password matching [A-Za-z0-9?!]{1,3} encrypted using SHA1 or SHA256.
    public func decrypt(shaHash: String) -> String? {
        return mappingToPlaintext[shaHash]
    }
}
