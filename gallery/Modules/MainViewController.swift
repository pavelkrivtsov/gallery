//
//  MainViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2022.
//

import UIKit

protocol MainViewInput: AnyObject {
    func showCurrentPhoto(viewController: UIViewController)
}

class MainViewController: UIViewController {
    
    private let presenter: MainViewOutput
    private let tableView: UITableView
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
        tableView.frame = self.view.bounds
        presenter.loadList()
    }
}

// MARK: - UINavigationController
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

// MARK: - MainViewInput
extension MainViewController: MainViewInput {
    
    func showCurrentPhoto(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text, !searchText.isEmpty  {
            presenter.clearList()
            presenter.loadFoundList(from: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            presenter.clearList()
            presenter.loadList()
        }
    }
}
