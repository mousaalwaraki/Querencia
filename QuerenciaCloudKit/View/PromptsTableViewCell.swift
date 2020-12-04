//
//  PromptsTableViewCell.swift
//  Journal
//
//  Created by Mousa Alwaraki on 8/23/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit
import CoreData

protocol PromptsCellDelegate {
    func promptAddedShow()
}

class PromptsTableViewCell: UITableViewCell {

    @IBOutlet weak var promptContainer: UIView!
    @IBOutlet weak var promptTextView: UITextView!
    @IBOutlet weak var promptAddButton: UIButton!
    
    var vc: InspirationViewController?
    var delegate : PromptsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        promptContainer.setCard()
        promptContainer.layer.cornerRadius = 12
    }

    @IBAction func promptAddButtonTapped(_ sender: Any) {
        
        vc?.userPrompts.append(promptTextView.text)
        vc?.allPrompts.removeAll(where: ({$0 == promptTextView.text}))
        vc?.promptsTableView.reloadData()
        delegate?.promptAddedShow()
        
    }
}
