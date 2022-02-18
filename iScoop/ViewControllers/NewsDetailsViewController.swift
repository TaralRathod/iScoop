//
//  NewsDetailsViewController.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import UIKit

class NewsDetailsViewController: UIViewController {

    @IBOutlet weak var newsDetailsTableview: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var articles: [Articles]?
    var indexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableview()
        let radius = backButton.frame.width / 2
        backButton.addCornerRadius(radius: radius, borderColor: .clear, borderWidth: 1.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            guard let indexPath = self.indexPath else {return}
            self.newsDetailsTableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    func setupTableview() {
        newsDetailsTableview.delegate = self
        newsDetailsTableview.dataSource = self
        newsDetailsTableview.tableFooterView = UIView()
        newsDetailsTableview.estimatedRowHeight = UIScreen.main.bounds.height
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension NewsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let article = articles?[indexPath.row] else {return UITableViewCell()}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsDetailsCell, for: indexPath) as? NewsDetailsCell else {return UITableViewCell()}
        cell.setupUI(article: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
