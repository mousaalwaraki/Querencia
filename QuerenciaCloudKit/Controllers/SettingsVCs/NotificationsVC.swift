//
//  NotificationsViewController.swift
//  Journal
//
//  Created by Mousa Alwaraki on 5/23/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var viewForBackground: UIView!
    @IBOutlet weak var timePickerButton: UIButton!
    
    var timePickerTime = ""
    
    @IBAction func touchOnView(_ sender: Any) {
        if viewForBackground.alpha == 0 {
            return
        } else {
            self.heightConstraintTimePicker.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.viewForBackground.alpha = 0
                self.view.layoutIfNeeded()
            }
            timePickerButton.setTitle("Change Time", for: .normal)
            LocalNotificationManager.shared.scheduleNotifications()
        }
    }
    
    @IBAction func timePickerButtonTapped(_ sender: Any) {
        var date = Date()
        date = Calendar.current.date(bySetting: .hour, value: Utilities.userHour, of: date)!
        date = Calendar.current.date(bySetting: .minute, value: Utilities.userMinute, of: date)!
        timePicker.setDate(date, animated: false)
        popUpTimePicker()
    }
    
    @IBAction func timePickerValueChanged(_ sender: Any) {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timePickerTime = formatter.string(from: timePicker.date)
        timeLabel.text = timePickerTime
        
        let userHour = Calendar.current.component(.hour, from: timePicker.date)
        let userMinute = Calendar.current.component(.minute, from: timePicker.date)
        
        UserDefaults.standard.set(userHour, forKey: "userHour")
        UserDefaults.standard.set(userMinute, forKey: "userMinute")
        
        LocalNotificationManager.shared.scheduleNotifications()
    }
    
    var heightConstraintTimePicker: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heightConstraintTimePicker = NSLayoutConstraint(item: timePicker!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0)
        heightConstraintTimePicker.isActive = true
        viewForBackground.alpha = 0
        
        timeLabel.text = "\(Utilities.userHour):\(String(format: "%02d", Utilities.userMinute))"
    }


    func popUpTimePicker() {
        if self.heightConstraintTimePicker.constant == 0 {
            timePicker.backgroundColor = .secondarySystemBackground
            timePicker.clipsToBounds = true
            self.heightConstraintTimePicker.constant = 300
            UIView.animate(withDuration: 0.3) {
                self.viewForBackground.alpha = 0.5
                self.view.layoutIfNeeded()
            }
            timePicker.layer.cornerRadius = 20
            timePickerButton.setTitle("", for: .normal)
            return
        } else if self.heightConstraintTimePicker.constant == 216 {
            self.heightConstraintTimePicker.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.viewForBackground.alpha = 0
                self.view.layoutIfNeeded()
            }
            timePickerButton.setTitle("Change Time", for: .normal)
        }
    }
}
