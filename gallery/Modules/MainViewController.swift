//
//  MainViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2022.
//

import UIKit

protocol MainViewOutput: AnyObject {
    func clearList()
    func loadList()
    func loadFoundList(from text: String)
}

protocol MainViewInput: AnyObject {
    func showCurrentPhoto(viewController: UIViewController)
}

class MainViewController: UIViewController {
    
    private var presenter: MainViewOutput
    private var tableView: UITableView
    private let searchController = UISearchController(searchResultsController: nil)
         
    init(presenter: MainViewOutput, tableView: UITableView) {
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

extension MainViewController: MainViewInput {
    
    func showCurrentPhoto(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
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
