//
//  HeighlightNewsCell.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import UIKit

class HeighlightNewsCell: UITableViewCell {

    @IBOutlet weak var heighlightImageView: UIImageView!
    @IBOutlet weak var highlightNewsLabel: UILabel!

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
            heighlightImageView.setGradientBackground(topColor: .clear,
                                                      bottomColor: .black)
        } else {
            stopShimmerEffect()
            guard let model = modal else {return}
            heighlightImageView.image = UIImage.init(named: model.content ?? Constants.blankString)
            highlightNewsLabel.text = model.title ?? Constants.blankString
        }
    }

    func startShimmerEffect() {
        heighlightImageView.startShimmering()
        highlightNewsLabel.startShimmering()
    }

    func stopShimmerEffect() {
        heighlightImageView.stopShimmering()
        highlightNewsLabel.stopShimmering()
    }
}
