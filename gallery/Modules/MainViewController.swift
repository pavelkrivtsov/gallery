//
//  MainViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2022.
//

import UIKit
import Kingfisher

//protocol MainViewControllerProtocol: AnyObject {
//    func setList(from photos: [Photo])
//}

class MainViewController: UIViewController {
    
    private var presenter: MainPresenterProtocol
    private var tableView: UITableView
    private let searchController = UISearchController(searchResultsController: nil)
         
    init(presenter: MainPresenterProtocol, tableView: UITableView) {
        self.presenter = presenter
        self.tableView = tableView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        self.tableView.frame = self.view.bounds
        presenter.loadList()
    }
}

extension MainViewController {
    func embedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        searchController.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photos"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController.navigationBar.topItem?.backButtonTitle = ""
        navigationController.navigationBar.tintColor = UIColor.init(named: "AccentColor")
        return navigationController
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty  {
            self.presenter.clearList()
            self.presenter.loadFoundList(from: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            self.presenter.clearList()
            self.presenter.loadList()
        }
    }
}

//extension MainViewController: MainViewControllerProtocol {
//    func setList(from photos: [Photo]) {
//        self.photos = self.photos + photos
//        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
//        snapshot.appendSections([0])
//        snapshot.appendItems(self.photos)
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
//}
