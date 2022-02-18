//
//  ViewController.swift
//  iScoop
//
//  Created by Taral Rathod on 15/02/22.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var connectionErrorLabel: UILabel!
    @IBOutlet weak var connectionErrorViewHeight: NSLayoutConstraint!
    
    var newsViewModel: NewsViewModel?
    var articles: [Articles]?
    var isConnectionError = false
    var selectedImage: UITableViewCell?
    let transition = PopAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForAPIKey()
    }

    func setupTableview() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView()
        newsTableView.rowHeight = 44.0
    }

    func checkForAPIKey() {
        if Constants.apiKey == Constants.blankString {
            showAPIKeyAlert()
        } else {
            newsViewModel = NewsViewModel(delegate: self)
            newsViewModel?.fetchHeadlines(network: NetworkManager())
            setupTableview()
        }
    }

    func showAPIKeyAlert() {
        newsTableView.isHidden = false
        let alert = UIAlertController(title: Constants.apiKeyErrorTitle, message: Constants.apiKeyErrorMessage, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)

            coordinator.animate(
              alongsideTransition: {context in
              },
              completion: nil
            )
          }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isConnectionError {
            if articles?.count == 0 {
                connectionErrorLabel.isHidden = false
                return 0
            } else {
                connectionErrorViewHeight.constant = 90
                return articles?.count ?? 5
            }
        }
        connectionErrorViewHeight.constant = 0
        return articles?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles?[indexPath.row]
        let shouldBeLoading = article == nil
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.heighlightCell, for: indexPath) as? HeighlightNewsCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupUI(shouldBeLoading: shouldBeLoading, modal: article)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCell, for: indexPath) as? NewsCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupUI(shouldBeLoading: shouldBeLoading, modal: article)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.mainStroyboard, bundle: nil)
        selectedImage = tableView.cellForRow(at: indexPath)
        guard let destinationVC = storyBoard.instantiateViewController(withIdentifier: String(describing: NewsDetailsViewController.self)) as? NewsDetailsViewController else {return}
        destinationVC.articles = articles
        destinationVC.indexPath = indexPath
        destinationVC.transitioningDelegate = self
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? UIScreen.main.bounds.height / 2.15 : UITableView.automaticDimension
    }
    
}

extension NewsViewController: NewsProtocol {
    func headlinesReceived(headlines: TopHeadlines, isConnectionError: Bool) {
        DispatchQueue.main.async {
            guard let articles = headlines.articles?.array as? [Articles] else {return}
            self.articles = articles
            self.isConnectionError = isConnectionError
            self.newsTableView.reloadData()
        }
    }
}

extension NewsViewController: UIViewControllerTransitioningDelegate {

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)

    transition.presenting = true
//    selectedImage!.isHidden = true

    return transition
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.presenting = false
    return transition
  }
}
