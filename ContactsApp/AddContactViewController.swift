//  Created by Mihael Matyatsko on 14.07.2021.

import Foundation
import UIKit

class AddContactViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    //MARK: - Const&Vars
    let plistManager = PlistFileManager()
    let ContactsVC = ContactsViewController()
    var flag = false
//MARK: - View did load method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateTheme()
    }
//MARK: - WillAppear to hold up to date theme
    override func viewWillAppear(_ animated: Bool) {
        updateTheme()
    }
    
}
