//
//  MainViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2022.
//

import UIKit
import Kingfisher

protocol MainViewControllerProtocol: AnyObject {
    func setList(from photos: [Photo])
}

class MainViewController: UITableViewController {
    
    private var presenter: MainPresenterProtocol
    private let searchController = UISearchController(searchResultsController: nil)
    private var dataSource: UITableViewDiffableDataSource<Int, Photo>!
    private var photos = [Photo]()
    private var currentPage = 1
    private var searchText = ""
     
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.cellIdentifier)
        
        dataSource = UITableViewDiffableDataSource<Int, Photo>(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.cellIdentifier,
                                                           for: indexPath) as? PhotoCell else {
                fatalError("ImageCell is not registered for table view")
            }
            cell.configure(photo: item)
            return cell
        }
        
        presenter.loadList(for: self.currentPage)
    }
    
    override func viewWillLayoutSubviews() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = self.photos[indexPath.item]
        let heightPerItem = CGFloat(photo.width) / CGFloat(photo.height)
        return tableView.frame.width / heightPerItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        presenter.showPhoto(photo: photo)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = self.photos.count - 1
        if indexPath.row == lastIndex {
            self.currentPage += 1
            if !self.searchText.isEmpty {
                self.presenter.loadFoundList(from: self.searchText, for: self.currentPage)
            } else {
                self.presenter.loadList(for: self.currentPage)
            }
        }
    }
}

extension MainViewController {
    func embedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        searchController.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photos"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        return navigationController
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.photos.removeAll()
        self.currentPage = 1
        
        if let searchText = searchBar.text {
            self.searchText = searchText
            self.presenter.loadFoundList(from: searchText, for: self.currentPage)
        } else {
            self.presenter.loadList(for: self.currentPage)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.photos.removeAll()
        self.currentPage = 1
        self.presenter.loadList(for: self.currentPage)
    }
}

extension MainViewController: MainViewControllerProtocol {
    func setList(from photos: [Photo]) {
        self.photos = self.photos + photos
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.photos)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
