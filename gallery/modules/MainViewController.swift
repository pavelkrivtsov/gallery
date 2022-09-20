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
    var imageList = [UnsplashPhoto]()
    
    init(presenter: MainPresenterIn) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "//"
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.cellIdentifier)
        presenter.setupImageList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.imageList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.cellIdentifier, for: indexPath) as! ImageCell
        let unsplashPhoto = imageList[indexPath.item]
        cell.configure(image: unsplashPhoto)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      let currentImage = imageList[indexPath.item]
      let heightPerItem = CGFloat(currentImage.width) / CGFloat(currentImage.height)
      return tableView.frame.width / heightPerItem
    }
}

extension MainViewController {
    func embedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
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
    func setImageList(imageList: [UnsplashPhoto]) {
        self.imageList = imageList
        tableView.reloadData()
    }
}
