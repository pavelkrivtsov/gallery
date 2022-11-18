//
//  MainAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit

class MainAssembly {
    static func assemle() -> UINavigationController {
        let tableView = UITableView()
        let tableManager = MainTableManager(tableView: tableView)
        let networkService = NetworkService()
        let router = MainRouter()
        let presenter = MainPresenter(networkDataFetcher: networkService, tableManager: tableManager, router: router)
        tableManager.presenter = presenter
        let view = MainViewController(presenter: presenter, tableView: tableView)
//        presenter.view = view
        router.view = view
        return view.embedInNavigationController()
    }
}
