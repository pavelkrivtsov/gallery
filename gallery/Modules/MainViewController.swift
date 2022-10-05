//
//  MainViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2022.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func setImageList(imageList: [UnsplashImage])
}

class MainViewController: UITableViewController {
    
    private var presenter: MainPresenterProtocol
    private let searchController = UISearchController(searchResultsController: nil)
    private var dataSource: UITableViewDiffableDataSource<Int, UnsplashImage>!
    private var images = [UnsplashImage]()
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "//"
        tableView.separatorStyle = .none
        tableView.register(MainImageCell.self, forCellReuseIdentifier: MainImageCell.cellIdentifier)
        
        dataSource = UITableViewDiffableDataSource<Int, UnsplashImage>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainImageCell.cellIdentifier,
                                                           for: indexPath) as? MainImageCell else {
                fatalError("ImageCell is not registered for table view")
            }
            cell.configure(image: itemIdentifier)
            return cell
        }
        
        presenter.loadImageList()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = images[indexPath.item]
        let heightPerItem = CGFloat(image.width) / CGFloat(image.height)
        return tableView.frame.width / heightPerItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = images[indexPath.item]
        presenter.showImage(image: image)
    }
}

extension MainViewController {
    func embedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        searchController.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photos, collections, users"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        return navigationController
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.presenter.loadFoundImages(searchText: searchText)
        }
    }
}

extension MainViewController: MainViewControllerProtocol {
    func setImageList(imageList: [UnsplashImage]) {
        self.images = imageList
        var snapshot = NSDiffableDataSourceSnapshot<Int, UnsplashImage>()
        snapshot.appendSections([0])
        snapshot.appendItems(images)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
