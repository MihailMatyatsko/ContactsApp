//  Created by Mihael Matyatsko on 14.07.2021.

import Foundation
import UIKit

class SettingsViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var infoRepresentationSegmentControll: UISegmentedControl!
    @IBOutlet weak var darkModeSwitcher: UISwitch!
    
//MARK: - Const&Vars
    let mainVC = ContactsViewController()
    var settingsTheme = UIUserInterfaceStyle.unspecified
    static let ON_OFF_DARK_THEME = "dark"
    static let INFO_ORDER = "order"
    
//MARK: - View did load (transfer theme parametrs variable)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTheme = setupUI()
        
    }

//MARK: - Setting User Defaults on state dark or light mode
    @IBAction func darkModeTurnOnOff(_ sender: UISwitch) {
        if darkModeSwitcher.isOn{
            mainVC.userDefaults.set(true, forKey: SettingsViewController.ON_OFF_DARK_THEME)
            view.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        } else {
            mainVC.userDefaults.set(false, forKey: SettingsViewController.ON_OFF_DARK_THEME)
            view.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
        }
    }

//MARK: - Immediate apply chosen theme to curr VC and check theme on app start
    func setupUI() -> UIUserInterfaceStyle {
        
        if let value = mainVC.userDefaults.value(forKey: SettingsViewController.INFO_ORDER){
           let selectedIndex = value as! Int
            infoRepresentationSegmentControll.selectedSegmentIndex = selectedIndex
        }
        
        if mainVC.userDefaults.bool(forKey: SettingsViewController.ON_OFF_DARK_THEME){
            darkModeSwitcher.setOn(true, animated: true)
            view.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
            return UIUserInterfaceStyle.light
        } else {
            darkModeSwitcher.setOn(false, animated: true)
            view.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
            return UIUserInterfaceStyle.dark
        }
        
    }
    
//MARK: - Segue to transfer theme paramets to main VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue"{
            guard let dest = segue.destination as? ContactsViewController else { return }
            dest.theme = settingsTheme
        }
    }
    
//MARK: - Setting user defaults for info order
    @IBAction func rememberSegmentState(_ sender: UISegmentedControl){
        mainVC.userDefaults.set(infoRepresentationSegmentControll.selectedSegmentIndex, forKey: SettingsViewController.INFO_ORDER)
    }
    

}
