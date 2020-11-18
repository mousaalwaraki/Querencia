//
//  AddingResourcesViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/12/20.
//

import UIKit

class AddingResourcesViewController: UIViewController {

    @IBOutlet weak var titleFT: UITextField!
    @IBOutlet weak var subtitleFT: UITextField!
    @IBOutlet weak var actionFT: UITextField!
    @IBOutlet weak var imageFT: UITextField!
    @IBOutlet weak var categoryFT: UITextField!
    @IBOutlet weak var numberFT: UITextField!
    @IBOutlet weak var segmentedColor: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    @IBAction func segmentControl(_ sender: Any) {
        let textFieldsArray : [UITextField] = [titleFT, subtitleFT, actionFT, imageFT, categoryFT, numberFT]
        if segmentedColor.selectedSegmentIndex == 0 {
            for field in textFieldsArray {
                field.alpha = 1
            }
        } else if segmentedColor.selectedSegmentIndex == 1 {
            for field in textFieldsArray {
                field.alpha = 1
            }
            categoryFT.alpha = 0
        } else {
            for field in textFieldsArray {
                field.alpha = 0
            }
            titleFT.alpha = 1
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if segmentedColor.selectedSegmentIndex == 0 {
            PublicCoreDataManager().saveCurrent(titleFT.text!, subtitleFT.text!, actionFT.text!, imageFT.text!, categoryFT.text!, numberFT.text!)
            PublicCoreDataManager().saveAll(titleFT.text!, subtitleFT.text!, actionFT.text!, imageFT.text!, categoryFT.text!)
        } else if segmentedColor.selectedSegmentIndex == 1 {
            PublicCoreDataManager().saveAll(titleFT.text!, subtitleFT.text!, actionFT.text!, imageFT.text!, categoryFT.text!)
        } else if segmentedColor.selectedSegmentIndex == 2 {
            PublicCoreDataManager().saveQuote(titleFT.text!)
        } else {
            PublicCoreDataManager().savePrompt(titleFT.text!)
        }
    }
}
