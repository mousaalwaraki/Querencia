//
//  Extensions.swift
//  Pods
//
//  Created by Marawan Alwaraki on 23/03/2019.
//

import Foundation

extension UIView {
    
    func setCard() {
        if #available(iOS 13.0, *) {
            self.layer.shadowColor = UIColor.systemGray2.cgColor
        } else {
            self.layer.shadowColor = UIColor.lightGray.cgColor
        }
        
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        
        //        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 6).cgPath
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
