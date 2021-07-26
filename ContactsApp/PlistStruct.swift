import Foundation
import UIKit

struct Plist {
    
    enum PlistError: Error {
        case FileNotWritten
        case FileDoesNotExist
    }

    let name:String

    var sourcePath:String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return .none }
        return path
    }

    var destPath:String? {
        guard sourcePath != .none else { return .none }
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let temp = (dir as NSString).appendingPathComponent("\(name).plist")
        return temp
    }

    init?(name:String) {

        self.name = name

        let fileManager = FileManager.default

        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExists(atPath: source) else { return nil }

        if !fileManager.fileExists(atPath: destination) {

            do {
                try fileManager.copyItem(atPath: source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    init(name newFileName: String, ofType: String, toDirectory directory: String) {
        
        self.name = newFileName
        guard let _ = self.append(toPath: directory, withPathComponent: newFileName) else {
                return
        }
    }

    func getValuesInPlistFile() -> NSDictionary?{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }

    func getMutablePlistFile() -> NSMutableDictionary?{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }

    func addValuesToPlistFile(dictionary:NSDictionary) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            if !dictionary.write(toFile: destPath!, atomically: false) {
                print("File not written successfully")
                throw PlistError.FileNotWritten
            }
        } else {
            throw PlistError.FileDoesNotExist
        }
    }
    
    func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            print(pathURL.absoluteString)
            return pathURL.absoluteString
        }
        
        return nil
    }
    
}

