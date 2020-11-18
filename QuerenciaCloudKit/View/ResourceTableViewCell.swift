//
//  ResourceTableViewCell.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import Haneke

class ResourceTableViewCell: UITableViewCell {

    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var news: ResourceModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containingView.setCard()
        containingView.subviews.first?.layer.cornerRadius = 12
        containingView.subviews.first?.layer.masksToBounds = true
    }
    
    func setup(with news: ResourceModel) {
        headerImageView.hnk_setImageFromURL(URL(string: news.imageUrl!)!)
        titleLabel.text = news.title?.capitalized
        descriptionLabel.text = news.subtitle
        containingView.backgroundColor = .secondarySystemBackground
    }

}
