//
//  WhatsNewKitViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import WhatsNewKit

class WhatsNewKitViewController: UIViewController {

    var whatsN: WhatsNewViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presntInitialScreen()
    }
    
    func presntInitialScreen() {
        
        let firstItem = WhatsNew.Item(
            title: "Keep Track of your life",
            subtitle: "Effortlessly keep track of your mood and how your days have been",
            image: UIImage(systemName: "square.and.pencil")
        )
        // Themes Item
        let secondItem = WhatsNew.Item(
            title: "Easy Format",
            subtitle: "The simple Q&A format will save you time and help you keep up your journaling Habit",
            image: UIImage(systemName: "questionmark.square.fill")
        )
        // Installation Item
        let thirdItem = WhatsNew.Item(
            title: "Minamilistic UI",
            subtitle: "No unnecessary additions that put you off journaling",
            image: UIImage(systemName: "doc.plaintext")
        )
        
        
        // Initialize Items
        let items = [
            firstItem,
            secondItem,
            thirdItem,
        ]
        
        let whatsNew = WhatsNew(
            title: "Journaling Made Simple",
            items: items
        )
        
        var configuration = WhatsNewViewController.Configuration(
            theme: .red,
//            detailButton: .init(
//                // Detail Button Title
//                title: "Sign Up",
//                // Detail Button Action
//                action: .custom(action: { (transition) in
//                    let signUpVC = self.storyboard!.instantiateViewController(identifier: "SignUpViewController")
//                    self.whatsN?.present(signUpVC, animated: true)
//                })
//            ),
            completionButton: .init(
                // Completion Button Title
                title: "Login",
                // Completion Button Action
                action: .custom(action: { (transition) in
                    let loginVC = self.storyboard?.instantiateViewController(identifier: "tabBar")
                    self.whatsN?.present(loginVC!, animated: true)
                })
            )
        )
        
        configuration.itemsView.animation = .slideRight
        
        // Set secondary color on TitleView Configuration
        configuration.titleView.secondaryColor = .init(
            // The start index
            startIndex: 0,
            // The length of characters
            length: 10,
            // The secondary color to apply
            color: .whatsNewKitRed
        )
        
        // Initialize WhatsNewViewController with WhatsNew
        whatsN = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )
            
        // Present it 🤩
        whatsN?.modalPresentationStyle = .fullScreen
        self.present(whatsN!, animated: true)
    }
}
