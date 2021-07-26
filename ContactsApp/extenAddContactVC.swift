//
//  extenAddContactVC.swift
//  ContactsApp
//
//  Created by Mihael Matyatsko on 20.07.2021.
//

import UIKit

extension AddContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

//MARK: - Configure UI
    func setupView(){
        contactImageView.layer.cornerRadius = 0.5 * contactImageView.bounds.width
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        contactImageView.isUserInteractionEnabled = true
        contactImageView.addGestureRecognizer(tapGestureRecognizer)
        flag = false
    }
//MARK: - Update theme
    func updateTheme() {
        if ContactsVC.userDefaults.bool(forKey: SettingsViewController.ON_OFF_DARK_THEME){
            view.overrideUserInterfaceStyle = .light
        } else {
            view.overrideUserInterfaceStyle = .dark
        }
    }
    
// MARK: - Tap recognizer toUIImageView to add photos (also alert message)
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        _ = tapGestureRecognizer.view as! UIImageView
        
        let alert = UIAlertController(title: "Confirm Action", message: "Choose where you want to take up photo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.chooseImage(.camera)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.chooseImage(.photoLibrary)
        }))
        present(alert, animated: true, completion: nil)
    }
    
//MARK: - Choose image function
    func chooseImage(_ imageSource: ImageSource){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        switch imageSource{
        case .camera:
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            vc.sourceType = .camera
        case .photoLibrary:
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
//MARK: - image picker controller setup
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            contactImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    enum ImageSource{
        case camera
        case photoLibrary
    }
    
//MARK: - Adding info to dictionary and to plist file
    @IBAction func saveContactData(_ sender: UIButton) {
        if nameField.text != "" && mobileNumberField.text != "" && contactImageView.image != nil{
            let filename = "\(plistManager.generateName).plist"
            let dict = NSMutableDictionary()
            dict["Name"] = nameField.text
            dict["Surname"] = surnameField.text
            dict["PhoneNumber"] = mobileNumberField.text
            dict["email"] = emailField.text
            dict["imgPath"] = saveImage(image: contactImageView.image!, imageName: filename)
            
            plistManager.saveToPlistFile(dictionary: dict, toDirectory: plistManager.documentDirectory() + "/Contacts", withFileName: filename)
           
            
            navigationController?.popViewController(animated: true)
        } else {
            let alertInAddContact = UIAlertController(title: "Not all nessesary info is mentioned", message: "Add avatar, name and phone number", preferredStyle: .alert)
            alertInAddContact.addAction(UIAlertAction(title: "Dismiss adding contact", style: .destructive, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            alertInAddContact.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            
            present(alertInAddContact, animated: true, completion: nil)
        }
        
    }
    
//MARK: - Saving modified image to /Contacts/Images
    func saveImage(image: UIImage, imageName: String ) -> String{
       
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var fileName = imageName
        for _ in 0..<Constants.sizeOfplistFileExtension {
            fileName.removeLast()
        }
        fileName.append("jpg")
        var fileURL = documentsDirectory.appendingPathComponent("Contacts")
        fileURL = fileURL.appendingPathComponent("Images")
        fileURL = fileURL.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                return fileName
            } catch {
                print("error saving file:", error)
            }
        }
        return ""
    }
    
}
