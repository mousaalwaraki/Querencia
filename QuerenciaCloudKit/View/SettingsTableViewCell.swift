//
//  SettingsTableViewCell.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import LocalAuthentication

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    var item: SettingsItem!
    let context:LAContext = LAContext()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingsImageView.layer.cornerRadius = 6
    }
    
    @IBAction func switchToggled(_ sender: Any) {
        if item == .password {
            if settingsSwitch.isOn {
                UserDefaults.standard.set(true, forKey: "Password")
            } else {
                UserDefaults.standard.set(false, forKey: "Password")
            }
        }
    }
    
    func setup(with item: SettingsItem) {
        self.item = item
        
        settingsLabel.text = item.title
        settingsImageView.image = item.image?.imageWithInsets(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))?.withRenderingMode(.alwaysTemplate)
        settingsImageView.backgroundColor = item.color
        
            settingsSwitch.isHidden = true
            isUserInteractionEnabled = true
            selectionStyle = .default
            accessoryType = .disclosureIndicator
        
        if item == .password {
            if UserDefaults.standard.value(forKey: "Password") as? Bool == true {
                settingsSwitch.isOn = true
            } else {
                settingsSwitch.isOn = false
            }
        }
    }
}
