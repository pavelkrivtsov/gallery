//
//  MainTableManager.swift
//  gallery
//
//  Created by Павел Кривцов on 17.11.2022.
//

import UIKit

protocol MainTableManagerOutput {
    func clearList()
    func setList(from photos: [Photo], isSearch: Bool)
}

class MainTableManager: NSObject {
    
    weak var presenter: MainTableManagerInput?
    private let tableView: UITableView
    private var dataSource: UITableViewDiffableDataSource<Int, Photo>!
    private var photos = [Photo]()
    private var isSearch: Bool = false
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.cellIdentifier)
        
        dataSource = UITableViewDiffableDataSource<Int, Photo>(tableView: self.tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.cellIdentifier,
                                                           for: indexPath) as? PhotoCell else {
                fatalError("ImageCell is not registered for table view")
            }
            cell.configure(photo: item)
            return cell
        }
    }
}

extension MainTableManager: MainTableManagerOutput {
    
    func clearList() {
        self.photos.removeAll()
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.photos)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func setList(from photos: [Photo], isSearch: Bool) {
        self.isSearch = isSearch
        self.photos += photos
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.photos)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MainTableManager: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = self.photos[indexPath.item]
        let heightPerItem = CGFloat(photo.width) / CGFloat(photo.height)
        return tableView.frame.width / heightPerItem
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        let photo = photos[indexPath.item]
        self.presenter?.showPhoto(photo: photo)
        generator.impactOccurred()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = self.photos.count - 1
        if indexPath.row == lastIndex {
            self.presenter?.willDisplay(isSearch: self.isSearch)
        }
    }
}
