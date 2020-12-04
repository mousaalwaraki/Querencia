//
//  AuthenticateViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import LocalAuthentication

class AuthenticateViewController: UIViewController {

    @IBOutlet weak var retryView: UIView!
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticatePassword()
        retryView.setCard()
        retryView.backgroundColor = .whatsNewKitRed
        retryButton.tintColor = .white
    }
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        authenticatePassword()
    }
    
    func authenticatePassword() {
        let context:LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error:nil) {
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Message") { (success, fail) in
                if success {
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBar")
                        UIApplication.shared.windows.first?.rootViewController =  vc
                    }
                } else {
                    
                }
            }
        } else {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBar")
                UIApplication.shared.windows.first?.rootViewController =  vc
            }
        }
    }
}
