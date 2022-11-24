//
//  DetailPhotoInfoViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

class DetailPhotoInfoViewController: UIViewController {
    
    private var presenter: DetailPhotoInfoViewOutput
    private var tableView: UITableView
    
    init(presenter: DetailPhotoInfoViewOutput, tableView: UITableView) {
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
    
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        let imageView = UIImageView(image: .init(systemName: "info.circle.fill"))
        navigationItem.titleView = imageView
    }
}
