//
//  SearchViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 28.09.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var presenter: SearchPresenterIn
    let searchController = UISearchController(searchResultsController: nil)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var images = [UnsplashImage]()
    
    init(presenter: SearchPresenterIn) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        presenter.setupImageList()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        collectionView.dataSource = self
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.cellIdentifier)
        collectionView.collectionViewLayout =  createShowcaseSection()
    }
    
    private func createShowcaseSection() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, repeatingSubitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.cellIdentifier, for: indexPath) as! SearchCell
        let unsplashPhoto = images[indexPath.item]
        cell.configure(image: unsplashPhoto)
        return cell
    }
}

extension SearchViewController {
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.presenter.fetchSearchigImages(searchText: searchText)
        }
    }
}

extension SearchViewController: SearchPresenterOut {
    func setImageList(imageList: [UnsplashImage]) {
        self.images = imageList
        collectionView.reloadData()
    }
}
