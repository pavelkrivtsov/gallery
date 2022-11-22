//
//  DetailPhotoInfoAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

class DetailPhotoInfoAssembly {
    static func assemble(from photo: Photo) -> UIViewController {
        let tableView = UITableView()
        let tableManager = DetailTableManager(tableView: tableView)
        let presenter = DetailPhotoInfoPresenter(photo: photo, tableManager: tableManager)
        let view = DetailPhotoInfoViewController(presenter: presenter, tableView: tableView)
        return view
    }
}
