//
//  DetailPhotoInfoViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

class DetailPhotoInfoViewController: UIViewController {
    private var presenter: DetailPhotoInfoPresenterProtocol
    public var tableView: UITableView
    
    init(presenter: DetailPhotoInfoPresenterProtocol, tableView: UITableView) {
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
        presenter.getDetailInfo()
    }
}
