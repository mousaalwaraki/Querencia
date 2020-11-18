//
//  QuestionsTableViewCell.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/14/20.
//

import UIKit

protocol QuestionCellDelegate {
    func updateArray(cell: UITableViewCell)
}

class QuestionsTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var questionsTextView: UITextView!
    var delegate: QuestionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        questionsTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateArray(cell: self)
    }
}
