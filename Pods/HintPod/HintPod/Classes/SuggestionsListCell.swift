//
//  SuggestionsListCell.swift
//  HintPod
//
//  Created by Marawan Alwaraki on 23/03/2019.
//

import UIKit

protocol SuggCellDelegate: class {
    func tappedUpvote(_ cell: SuggestionsListCell, selected: Bool)
    func tappedDownvote(_ cell: SuggestionsListCell, selected: Bool)
}

class SuggestionsListCell: UITableViewCell {

    @IBOutlet weak var groupedView: UIView!
    @IBOutlet weak var suggestionTitle: UILabel!
    @IBOutlet weak var suggestionDescription: UILabel!
    @IBOutlet weak var suggestionStatus: UILabel!
    
    @IBOutlet weak var upvoteBtn: UIButton!
    @IBOutlet weak var downvoteBtn: UIButton!
    
    weak var delegate: SuggCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if (groupedView != nil) {
            self.groupedView.setCard()
            self.groupedView.layer.cornerRadius = 12
        }
        
        self.upvoteBtn.tintColor = .green
        self.downvoteBtn.tintColor = .red
    }
    
    func loadCell(with suggestion: Suggestion) {
        suggestionTitle.text = suggestion.title
        suggestionDescription.text = suggestion.content
        suggestionStatus.text = suggestion.status
    }
    
    func checkVotes(for userId: String, with suggestion: Suggestion) {
        let vote: Bool? = suggestion.votes[userId]
        
        upvoteBtn.isSelected = false
        downvoteBtn.isSelected = false

        if vote != nil {
            if vote! {
                upvoteBtn.isSelected = true
            } else {
                downvoteBtn.isSelected = true
            }
        }
    }

    @IBAction func tappedUpvote(_ sender: Any) {
        downvoteBtn.isSelected = false
        upvoteBtn.isSelected = !upvoteBtn.isSelected
        delegate?.tappedUpvote(self, selected: upvoteBtn.isSelected)
    }
    
    @IBAction func tappedDownvote(_ sender: Any) {
        upvoteBtn.isSelected = false
        downvoteBtn.isSelected = !downvoteBtn.isSelected
        delegate?.tappedDownvote(self, selected: downvoteBtn.isSelected)
    }
    
}

class UpvoteBtn: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bundle = Bundle(for: self.classForCoder)
        
        let upvoteUnselected = UIImage(named: "arrow-up-u", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        let upvoteSelected = UIImage(named: "arrow-up-s", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)

        setImage(upvoteUnselected, for: .normal)
        setImage(upvoteSelected, for: .selected)
    }
    
    override var isSelected: Bool {
        
        didSet {
            
            if isSelected {
                self.tintColor = UIColor(red:0.12, green:0.90, blue:0.39, alpha:1.0)
            } else {
                if #available(iOS 13.0, *) {
                    self.tintColor = .label
                } else {
                    self.tintColor = .darkGray
                }
            }
        }
    }
}

class DownvoteBtn: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bundle = Bundle(for: self.classForCoder)
        
        let upvoteUnselected = UIImage(named: "arrow-down-u", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        let upvoteSelected = UIImage(named: "arrow-down-s", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        
        setImage(upvoteUnselected, for: .normal)
        setImage(upvoteSelected, for: .selected)
    }
    
    override var isSelected: Bool {
        
        didSet {
            
            if isSelected {
                self.tintColor = UIColor(red:0.99, green:0.00, blue:0.21, alpha:1.0) //red
            } else {
                if #available(iOS 13.0, *) {
                    self.tintColor = .label
                } else {
                    self.tintColor = .darkGray
                }
            }
        }
    }
}


class CommentCell: UITableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lineView.backgroundColor = .random
    }
    
}
