//
//  ViewController.swift
//  iScoop
//
//  Created by Taral Rathod on 15/02/22.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableview()
    }

    func setupTableview() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView()
        newsTableView.rowHeight = 44.0
    }

//    func executeRequest() {
//        if let url = URL(string: "https://newsapi.org/v2/everything?q=keyword&apiKey=f66fd701dcd845adbe6aad2bc23c9e90") {
//            let resource = Resource(url: url,
//                                    method: .get)
//            let networkManager = NetworkManager()
//            networkManager.load(resource) { (result) in
//                switch result {
//                case .success(let data):
//                    print(data)
//                case .failure(let error):
//                    print(error)
//                }
//
//            }
//        }
//    }

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.heighlightCell, for: indexPath) as? HeighlightNewsCell else {return UITableViewCell()}
            cell.setupUI(shouldBeLoading: true, modal: nil)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCell, for: indexPath) as? NewsCell else {return UITableViewCell()}
            cell.setupUI(shouldBeLoading: true, modal: nil)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
