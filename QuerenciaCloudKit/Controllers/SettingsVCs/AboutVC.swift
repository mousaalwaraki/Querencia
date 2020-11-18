//
//  AboutVC.swift
//  Snappy Wins
//
//  Created by Marwan Elwaraki on 30/03/2020.
//  Copyright © 2020 marwan. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About"
        shareButton.layer.cornerRadius = 12
        shareButton.alpha = 1
        aboutLabel.text = "Querencia is the area in the arena taken by the bull to draw it's power and be at ease in a fight. It's the place where the bull feels safest and most at home.\n\nI believe that your journal is equivilant to that. It's a safe environment where you reflect on yourself, feel safe from judgement, be yourself completely and unapologetically! After all this journal is made by you, for you. So don't hold back, be yourself, reflect and learn!\n\nI understand reflection and self-improvement is a long difficult road, so take a look at the resources and get inspired by some of the prompts provided. Edit them, make them your own. I can only give you the tools, I'm doing the easy bit, the hard part is on you.\n\nI'm honored and feel previliged to be part of your journey for a better you. If you need any assistance or have any suggestions, feel free to contact me, I'm always eager to hear from you!"
        
//        Recently however, the more used definition is the place where one’s strength is drawn from; where one feels at home; the place where you are your most authentic self.\n\nAt Querencia we belive that should be your journal, where you feel comfortable enough to be your complete self. After all this journal is made by you, for you."
    }
    
    
    
    @IBAction func tappedShare(_ sender: Any) {
        
        guard let url = URL(string: "https://apps.apple.com/gb/app/querencia/id1512500064") else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
