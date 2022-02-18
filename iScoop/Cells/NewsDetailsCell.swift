//
//  NewsDetailsCell.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import UIKit

class NewsDetailsCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: EasyRendererImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postedAtLabel: UILabel!
    @IBOutlet weak var navigateToWebButton: UIButton!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var webURL: URL?
    var newsDetailsViewModel: NewsDetailsViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsDetailsViewModel = NewsDetailsViewModel(delegate: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI(article: Articles) {
        gradientView.setGradientBackground(topColor: .clear, bottomColor: .black)
        titleLabel.text = article.title ?? Constants.blankString
        descriptionLabel.text = article.content ?? Constants.blankString
        navigateToWebButton.addBlurEffect()
        imageHeight.constant = UIScreen.main.bounds.height / 2.15
    
        if article.likes == nil {
            likeButton.isHidden = true
            commentButton.isHidden = true
            newsDetailsViewModel?.fetchLikeAndComments(for: article, network: NetworkManager())
        } else {
            setLikesAndComments(article: article)
        }

        if let author = article.author {
            authorNameLabel.text = "\(Constants.author)\(author)"
        }

        guard let time = article.publishedAt else {return}
        let diffTime = time.difference()
        postedAtLabel.text = diffTime

        guard let placeholder = UIImage(named: Constants.placeholderImage) else {return}
        bannerImageView.image = placeholder
        guard let url = article.urlToImage else {return}
        bannerImageView.getImageFor(url: url, placeholder: placeholder) { [weak self] image, _ in
            DispatchQueue.main.async {
                self?.bannerImageView.image = image
            }
        }

        guard let url = article.url else {return}
        webURL = url
    }

    func setLikesAndComments(article: Articles) {
        likeButton.isHidden = false
        commentButton.isHidden = false
        likeButton.setTitle(article.likes ?? Constants.blankString, for: .normal)
        commentButton.setTitle(article.comments ?? Constants.blankString, for: .normal)
    }

    @IBAction func navigateToWebTapped(_ sender: Any) {
        guard let url = webURL else {return}
        UIApplication.shared.open(url)
    }
}

extension NewsDetailsCell: NewsDetailsProtocol {
    func likesAndCommentsReceived(article: Articles) {
        setLikesAndComments(article: article)
    }
}
