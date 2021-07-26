import UIKit

class PlistFileManager{
//MARK: - Variables
    var fileContactsArray: [String] = []
    var Contacts: [Contact] = []
    var generateName: Int{
        return generate()
    }
//MARK: - Constants
    
//MARK: - Getting document directory (cast to string)
    func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return documentDirectory[0]
    }
    
//MARK: - Modified method 'appendPathComponent' in order to use it with string component
    func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        return nil
    }

//MARK: - Function to generate file name for plist file(later this name will be used for .jpg file)
    func generate() -> Int {
        var temp = 0
        repeat {
            temp = Int.random(in: 0...Constants.maxAmountOfContacts)
        } while fileContactsArray.contains("\(temp).plist")
        
        return temp
    }

//MARK: - Saving contact information to plist file
    func saveToPlistFile(dictionary: NSDictionary, toDirectory directory: String, withFileName fileName: String){
        guard let filePath = self.append(toPath: directory, withPathComponent: fileName) else {
                return
        }
        
        if dictionary.write(toFile: filePath, atomically: true) {
            update(completion: nil)
        } else {
            print("Unable to write to file!")
        }
        
    }
    
//MARK: - Read plist file info and returning it as NSDictionary
    func readFile(plistFile name: String) -> NSMutableDictionary{
        guard let filePath = self.append(toPath: documentDirectory() + "/Contacts", withPathComponent: name) else {
            return [:]
        }
        
        guard let dict = NSMutableDictionary(contentsOfFile: filePath) else { return [:] }
        return dict
    }

//MARK: - Instant data source update for table view(after adding or deleting contacts)
    func update(completion: (() -> ())? ){
        let fileManager = FileManager.default
        var documents = try! fileManager.contentsOfDirectory(atPath: documentDirectory() + "/Contacts")
        
        documents.sort { $0 > $1 }
        documents.removeFirst()
        documents.removeLast()
        fileContactsArray = documents
        Contacts = []
        for i in 0..<fileContactsArray.count{
            let tdict = readFile(plistFile: fileContactsArray[i])
            var TContact = Contact()
                TContact.dataSourceFileName = fileContactsArray[i]
                TContact.Name = tdict.value(forKey: "Name") as? String
                TContact.Surname = tdict.value(forKey: "Surname") as? String
                TContact.mobileNumber = tdict.value(forKey: "PhoneNumber") as? String
                TContact.email = tdict.value(forKey: "email") as? String
                TContact.avatarName = tdict.value(forKey: "imgPath") as? String
            Contacts.append(TContact)
        }
        sortDataSource()
    }
   
//Sort Data Source Function
    func sortDataSource(){
        if UserDefaults.standard.value(forKey: SettingsViewController.INFO_ORDER) as? Int == 0{
            Contacts.sort { $0.Name! < $1.Name! }
        } else {
            Contacts.sort { $0.Surname! < $1.Surname! }
        }
    }
    
}
