//
//  MainViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2022.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func setPhotosList(photosList: [Photo])
}

class MainViewController: UITableViewController {
    
    private var presenter: MainPresenterProtocol
    private let searchController = UISearchController(searchResultsController: nil)
    private var dataSource: UITableViewDiffableDataSource<Int, Photo>!
    private var photos = [Photo]()
    
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
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.cellIdentifier)
        
        dataSource = UITableViewDiffableDataSource<Int, Photo>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.cellIdentifier,
                                                           for: indexPath) as? PhotoCell else {
                fatalError("ImageCell is not registered for table view")
            }
            cell.configure(photo: itemIdentifier)
            return cell
        }
        
        presenter.loadPhotosList()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.item]
        let heightPerItem = CGFloat(photo.width) / CGFloat(photo.height)
        return tableView.frame.width / heightPerItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        presenter.showPhoto(photo: photo)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
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
            self.presenter.loadFoundPhotos(searchText: searchText)
        }
    }
}

extension MainViewController: MainViewControllerProtocol {
    func setPhotosList(photosList: [Photo]) {
        self.photos = self.photos + photosList
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
