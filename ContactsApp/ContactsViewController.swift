//  Created by Mihael Matyatsko on 12.07.2021.

import UIKit

class ContactsViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var setingsBarButton: UIBarButtonItem!
    @IBOutlet weak var addContactBarButton: UIBarButtonItem!
    @IBOutlet weak var contactsTableView: UITableView!
    
//MARK: - Const&Vars
    let userDefaults = UserDefaults.standard
    var theme = UIUserInterfaceStyle.unspecified
    var numberOfLaunches: Int = 0
    let KEY_LAUNCH = "launch"
    let plistManager = PlistFileManager()
    
//MARK: - Checking all nessesary parameters on application start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plistManager.update {
            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }
        }
        saveNumberOfLaunches()
        showRatingPrompt()
        delegateAndDataSource()
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        plistManager.update {
            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }
        }
    }

//MARK: - Func to update theme
    func updateTheme(style: UIUserInterfaceStyle){
        view.overrideUserInterfaceStyle = style
    }
           
}
