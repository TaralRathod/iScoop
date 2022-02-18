//
//  HeighlightNewsCell.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import UIKit

class HeighlightNewsCell: UITableViewCell {

    @IBOutlet weak var heighlightImageView: EasyRendererImageView!
    @IBOutlet weak var highlightNewsLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
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
            gradientView.setGradientBackground(topColor: .clear,
                                                      bottomColor: .black)
            heighlightImageView.image = placeholder
        } else {
            stopShimmerEffect()
            guard let model = modal else {return}
            highlightNewsLabel.text = model.title ?? Constants.blankString
            guard let url = modal?.urlToImage else {return}
            heighlightImageView.getImageFor(url: url, placeholder: placeholder) { [weak self] image, _ in
                DispatchQueue.main.async {
                    self?.heighlightImageView.image = image
                }
            }
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
