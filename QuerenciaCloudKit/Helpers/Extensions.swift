//
//  Extensions.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import Foundation
import SafariServices
import UIKit

extension UIView {
    func setCard() {
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIViewController {
    func openUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true)
        }
    }
}

extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}

class Utilities {
    static var userHour: Int {
        var userHour = 20
        
        if UserDefaults.standard.value(forKey: "userHour") != nil {
            userHour = UserDefaults.standard.integer(forKey: "userHour")
        }
        
        return userHour
    }
    
    static var userMinute: Int {
        var userMinute = 0
        
        if UserDefaults.standard.value(forKey: "userMinute") != nil {
            userMinute = UserDefaults.standard.integer(forKey: "userMinute")
        }
        
        return userMinute
    }
}
