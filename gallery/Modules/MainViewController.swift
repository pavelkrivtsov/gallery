//
//  MainViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2022.
//

import UIKit

class MainViewController: UITableViewController {
    
    var presenter: MainPresenterIn
    let searchController = UISearchController(searchResultsController: nil)
    private var dataSource: UITableViewDiffableDataSource<Int, UnsplashImage>!
    private var images = [UnsplashImage]()
    
    init(presenter: MainPresenterIn) {
        self.presenter = presenter
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.cellIdentifier)
        
        dataSource = UITableViewDiffableDataSource<Int, UnsplashImage>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.cellIdentifier,
                                                           for: indexPath) as? ImageCell else {
                fatalError("ImageCell is not registered for table view")
            }
            cell.configure(image: itemIdentifier)
            return cell
        }
        
        presenter.setupImageList()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = images[indexPath.item]
        let heightPerItem = CGFloat(currentImage.width) / CGFloat(currentImage.height)
        return tableView.frame.width / heightPerItem
    }
}

extension MainViewController {
    func embedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
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
            self.presenter.fetchSearchigImages(searchText: searchText)
        }
    }
}

extension MainViewController: MainPresenterOut {
    func setImageList(imageList: [UnsplashImage]) {
        self.images = imageList
        var snapshot = NSDiffableDataSourceSnapshot<Int, UnsplashImage>()
        snapshot.appendSections([0])
        snapshot.appendItems(images)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
