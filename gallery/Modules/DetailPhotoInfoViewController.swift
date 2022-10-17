//
//  DetailPhotoInfoViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit
import SnapKit

protocol DetailPhotoInfoViewControllerProtocol: AnyObject {
    func showDetailInfo()
}

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
        presenter.getDetailInfo()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension DetailPhotoInfoViewController: DetailPhotoInfoViewControllerProtocol {
    func showDetailInfo() {
        view.backgroundColor = .green
    }
}
