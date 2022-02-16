//
//  NewsCell.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI(shouldBeLoading: Bool, modal: Article?) {
        if shouldBeLoading {
            startShimmerEffect()
        } else {
            stopShimmerEffect()
            guard let model = modal else {return}
            headerLabel.text = model.title ?? Constants.blankString
            detailLabel.text = model.description ?? Constants.blankString
            timeLabel.text = model.publishedAt ?? Constants.blankString
        }
    }

    func startShimmerEffect() {
        newsImageView.startShimmering()
        headerLabel.startShimmering()
        detailLabel.startShimmering()
        timeLabel.startShimmering()
    }

    func stopShimmerEffect() {
        newsImageView.stopShimmering()
        headerLabel.stopShimmering()
        detailLabel.stopShimmering()
        timeLabel.stopShimmering()
    }
}
