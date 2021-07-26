//  Created by Mihael Matyatsko on 14.07.2021.

import UIKit

class DetailContactsInfoViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var contactAvatar: UIImageView!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var ContactSurname: UITextField!
    @IBOutlet weak var contactMobileNumber: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var editContactButton: UIButton!
    
//MARK: - Variables
    var name: String?
    var surmane: String?
    var email: String?
    var mobNumber: String?
    var imageName: String?
    var plistName: String?
    
//MARK: - Constants
    let ContactsVC = ContactsViewController()
    let plistManager = PlistFileManager()
    
//MARK: - View did load Method(configure UI)
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIforDVC()
    }
    
//MARK: - SetupUI functions
    func setupUIforDVC() {
        redactorSettings(key: true)
        
        contactAvatar.layer.cornerRadius = 0.5 * contactAvatar.bounds.width
        contactName.text = name
        ContactSurname.text = surmane
        contactEmail.text = email
        contactMobileNumber.text = mobNumber
        if let tmpImage = loadImage(imageName: imageName!) {
            contactAvatar.image = tmpImage
        } else {
            contactAvatar.image = UIImage(named: "notFound")
        }
        updateTheme()
    }
    
    func updateTheme() {
        if ContactsVC.userDefaults.bool(forKey: SettingsViewController.ON_OFF_DARK_THEME){
            view.overrideUserInterfaceStyle = .light
        } else {
            view.overrideUserInterfaceStyle = .dark
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTheme()
    }

//MARK: - load image from /Documents/Images
    func loadImage(imageName: String) -> UIImage?{
        
        let fileManager = FileManager.default
        let imagePath = (self.plistManager.documentDirectory() as NSString).appendingPathComponent("/Contacts/Images/\(imageName)")
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)!
        }else{
            print("No Image available")
            return UIImage.init(named: "notFound")! 
        }
        
    }
//MARK: - Start and finish editing contact action
    @IBAction func enterEditContactMode(_ sender: UIButton) {
        if editContactButton.title(for: .normal) == "Edit Contact" {
            redactorSettings(key: false)
        } else {
            if contactName.text != name || ContactSurname.text != surmane || contactEmail.text != email || contactMobileNumber.text != mobNumber{
                let tmpDict = plistManager.readFile(plistFile: plistName!)
                tmpDict["Name"] = contactName.text
                tmpDict["Surname"] = ContactSurname.text
                tmpDict["PhoneNumber"] = contactMobileNumber.text
                tmpDict["email"] = contactEmail.text
                plistManager.saveToPlistFile(dictionary: tmpDict, toDirectory: plistManager.documentDirectory() + "/Contacts", withFileName: plistName!)
                redactorSettings(key: true)
                navigationController?.popViewController(animated: true)
            } else {
                redactorSettings(key: true)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
//MARK: - settings in ContactEditMode
    func redactorSettings(key: Bool){
        if key == false{
            editContactButton.setTitle("Save", for: .normal)
            editContactButton.backgroundColor = #colorLiteral(red: 0.1660016775, green: 0.9314249158, blue: 0.1660870016, alpha: 1)
            contactName.isUserInteractionEnabled = true
            ContactSurname.isUserInteractionEnabled = true
            contactMobileNumber.isUserInteractionEnabled = true
            contactEmail.isUserInteractionEnabled = true
        }
        if key == true{
            editContactButton.setTitle("Edit Contact", for: .normal)
            editContactButton.backgroundColor = #colorLiteral(red: 0, green: 0.476822257, blue: 1, alpha: 1)
            contactName.isUserInteractionEnabled = false
            ContactSurname.isUserInteractionEnabled = false
            contactMobileNumber.isUserInteractionEnabled = false
            contactEmail.isUserInteractionEnabled = false
        }
    }
    
    
}
