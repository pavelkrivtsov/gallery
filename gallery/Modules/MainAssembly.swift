//
//  MainAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit

class MainAssembly {
    
    static func assemble() -> UINavigationController {
        let searchController = UISearchController(searchResultsController: nil)
        let searchManager = SearchManager(searchController: searchController)
        let tableView = UITableView()
        let tableManager = MainTableManager(tableView: tableView)
        let networkService = NetworkManager()
        let presenter = MainPresenter(networkManager: networkService,
                                      tableManager: tableManager,
                                      searchManager: searchManager)
        tableManager.presenter = presenter
        searchManager.presenter = presenter
        let view = MainViewController(presenter: presenter,
                                      tableView: tableView,
                                      searchController: searchController)
        presenter.view = view
        return view.embedInNavigationController()
    }
}
