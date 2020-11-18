//
//  TopTagTableViewCell.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/15/20.
//

import UIKit

class TopTagTableViewCell: UITableViewCell {

    @IBOutlet weak var topPromptLabel: UILabel!
    @IBOutlet weak var topPromptImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
