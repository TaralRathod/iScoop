//
//  NewsCell.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var newsImageView: EasyRendererImageView!
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

    func setupUI(shouldBeLoading: Bool, modal: Articles?) {
        guard let placeholder = UIImage(named: Constants.placeholderImage) else {return}
        if shouldBeLoading {
            startShimmerEffect()
            newsImageView.image = placeholder
        } else {
            stopShimmerEffect()
            guard let model = modal else {return}
            headerLabel.text = model.title ?? Constants.blankString
            detailLabel.text = model.descriptions ?? Constants.blankString
            guard let time = modal?.publishedAt else {return}
            let diffTime = time.difference()
            timeLabel.text = diffTime
            guard let url = modal?.urlToImage else {return}
            newsImageView.getImageFor(url: url, placeholder: placeholder) { [weak self] image, _ in
                DispatchQueue.main.async {
                    self?.newsImageView.image = image
                }
            }
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
