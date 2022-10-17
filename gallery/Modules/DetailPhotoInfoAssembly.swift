//
//  DetailPhotoInfoAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

class DetailPhotoInfoAssembly {
    static func assemle(photo: Photo) -> UIViewController {
        let tableView = UITableView()
        let tableManager = TableManager()
        tableManager.setupTableView(tableView: tableView)
        let presenter = DetailPhotoInfoPresenter(photo: photo, tableManager: tableManager)
        let view = DetailPhotoInfoViewController(presenter: presenter, tableView: tableView)
        view.tableView = tableView
        presenter.view = view
        return view
    }
}
