import Foundation
import UIKit

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource{

//MARK: - SetupUI
    func setupUI(){
        title = "Contact list"
        
        if userDefaults.bool(forKey: SettingsViewController.ON_OFF_DARK_THEME)
        {
            view.overrideUserInterfaceStyle = .light
        } else {
            view.overrideUserInterfaceStyle = .dark
        }
        DispatchQueue.main.async {
            self.contactsTableView.reloadData()
        }
}
    
//MARK: - Configure Contacts table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plistManager.Contacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return contactsTableView.bounds.height - (Constants.deltaCellHeight * CGFloat(plistManager.Contacts.count))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if userDefaults.value(forKey: SettingsViewController.INFO_ORDER) as? Int == 0{
            cell.textLabel?.text = plistManager.Contacts[indexPath.row].Name
            cell.detailTextLabel?.text = plistManager.Contacts[indexPath.row].Surname
        } else {
            if plistManager.Contacts[indexPath.row].Surname == "" {
                cell.textLabel?.text = plistManager.Contacts[indexPath.row].Name
                cell.detailTextLabel?.text = plistManager.Contacts[indexPath.row].Surname
            } else {
                cell.textLabel?.text = plistManager.Contacts[indexPath.row].Surname
                cell.detailTextLabel?.text = plistManager.Contacts[indexPath.row].Name
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let fileManager = FileManager.default
            let file = plistManager.fileContactsArray[indexPath.row]
            var jpgFileName = file
            for _ in 0..<Constants.sizeOfplistFileExtension {
                jpgFileName.removeLast()
            }
            jpgFileName.append("jpg")
            var DocPath = plistManager.documentDirectory()
            let imgPath = (DocPath as NSString).appendingPathComponent("/Contacts/Images/\(jpgFileName)")
            if fileManager.fileExists(atPath: imgPath){
                do {
                    try fileManager.removeItem(atPath: imgPath)
                } catch {
                    print(error)
                }
            }
            DocPath = (DocPath as NSString).appendingPathComponent("/Contacts/\(file)")
            if fileManager.fileExists(atPath: DocPath){
                do {
                    try fileManager.removeItem(atPath: DocPath)
                } catch {
                    print(error)
                }
            }
            plistManager.fileContactsArray.remove(at: indexPath.row)
            plistManager.Contacts.remove(at: indexPath.row)
            contactsTableView.deleteRows(at: [indexPath], with: .automatic)
            plistManager.update {
                DispatchQueue.main.async {
                    self.contactsTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func enterEditModeTabView(_ sender: UIBarButtonItem){
        if contactsTableView.isEditing == false{
            contactsTableView.allowsSelectionDuringEditing = true
            contactsTableView.setEditing(true, animated: true)
        } else {
            contactsTableView.setEditing(false, animated: true)
        }
    }
    
    func delegateAndDataSource(){
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
//MARK: - Transfer detail contact info
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactInfo"{
            if let indexPath = contactsTableView.indexPathForSelectedRow{
                let dest = segue.destination as! DetailContactsInfoViewController
                dest.name = plistManager.Contacts[indexPath.row].Name
                dest.surmane = plistManager.Contacts[indexPath.row].Surname
                dest.email = plistManager.Contacts[indexPath.row].email
                dest.mobNumber = plistManager.Contacts[indexPath.row].mobileNumber
                dest.imageName = plistManager.Contacts[indexPath.row].avatarName
                dest.plistName = plistManager.Contacts[indexPath.row].dataSourceFileName
            }
        }
    }
//MARK: - Counting app launch
        func saveNumberOfLaunches(){
            numberOfLaunches = userDefaults.integer(forKey: KEY_LAUNCH)
            if numberOfLaunches != -1{
                numberOfLaunches += 1
            }
            userDefaults.setValue(numberOfLaunches, forKey: KEY_LAUNCH)
        }
//MARK: - Alert proposing rate this app
        func showRatingPrompt(){
            if numberOfLaunches == 3{
                let alert = UIAlertController(title: "Rate this app?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Go to AppStore!", style: .default, handler: { _ in
                    //open AppStore
                    self.numberOfLaunches = -1
                    self.userDefaults.setValue(self.numberOfLaunches, forKey: self.KEY_LAUNCH)
                    if let url = URL(string: "https://www.apple.com/app-store/") {
                        UIApplication.shared.open(url)
                    }
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "Later", style: .default, handler: { _ in
                    // just close
                    self.numberOfLaunches = 0
                    self.userDefaults.setValue(self.numberOfLaunches, forKey: self.KEY_LAUNCH)
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "I don't like it!", style: .destructive, handler: { _ in
                    //stop showing this prompt
                    self.numberOfLaunches = -1
                    self.userDefaults.setValue(self.numberOfLaunches, forKey: self.KEY_LAUNCH)
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    
}
