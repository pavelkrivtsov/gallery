//
//  MainViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2022.
//

import UIKit

protocol MainViewInput: AnyObject {
    func showSelectedPhoto(viewController: UIViewController)
    func failedLoadPhotos(_ alert: UIAlertController)
    func noFoundPhotos(_ view: NoPhotosView)
    func removeNoPhotosFromSuperview()
}

class MainViewController: UIViewController {
    
    private let presenter: MainViewOutput
    private let tableView: UITableView
    private let searchController: UISearchController
    private lazy var notificationGenerator = UINotificationFeedbackGenerator()
    private lazy var noPhotosView = NoPhotosView()
         
    init(presenter: MainViewOutput, tableView: UITableView, searchController: UISearchController) {
        self.presenter = presenter
        self.tableView = tableView
        self.searchController = searchController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        presenter.loadPhotos() 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
}

// MARK: - UINavigationController
extension MainViewController {
    
    func embedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController.navigationBar.topItem?.backButtonTitle = ""
        navigationController.navigationBar.tintColor = UIColor.init(named: "AccentColor")
        return navigationController
    }
}

// MARK: - MainViewInput
extension MainViewController: MainViewInput {
    
    func showSelectedPhoto(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func failedLoadPhotos(_ alert: UIAlertController) {
        self.present(alert, animated: true)
        notificationGenerator.notificationOccurred(.warning)
    }
    
    func noFoundPhotos(_ view: NoPhotosView) {
        self.noPhotosView = view
        self.noPhotosView.frame = self.view.bounds
        self.view.addSubview(view)
    }
    
    func removeNoPhotosFromSuperview() {
        self.noPhotosView.removeFromSuperview()
    }
}
