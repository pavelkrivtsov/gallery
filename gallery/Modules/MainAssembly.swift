//
//  MainAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit

class MainAssembly {
    static func assemble() -> UINavigationController {
        let tableView = UITableView()
        let tableManager = MainTableManager(tableView: tableView)
        let networkService = NetworkService()
        let presenter = MainPresenter(networkDataFetcher: networkService, tableManager: tableManager)
        tableManager.presenter = presenter
        let view = MainViewController(presenter: presenter, tableView: tableView)
        presenter.view = view
        return view.embedInNavigationController()
    }
}
