//
//  MainTableManager.swift
//  gallery
//
//  Created by Павел Кривцов on 17.11.2022.
//

import UIKit

protocol MainTableManagerOutput {
    func clearList()
    func appendPhotos(from photos: [Photo], totalPhotos: Int?, isSearch: Bool)
}

class MainTableManager: NSObject {
    
    weak var presenter: MainTableManagerInput?
    private let tableView: UITableView
    private var dataSource: UITableViewDiffableDataSource<Int, Photo>!
    private var photos = [Photo]()
    private var totalPhotos = Int()
    private var isSearch: Bool = false
    private lazy var generator = UIImpactFeedbackGenerator(style: .rigid)
    
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
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: .init(x: 0,
                                             y: 0,
                                             width: self.tableView.frame.width,
                                             height: self.tableView.frame.width / 5))
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = footerView.center
        footerView.addSubview(spinner )
        spinner.startAnimating()
        return footerView
    }
}

// MARK: - MainTableManagerOutput
extension MainTableManager: MainTableManagerOutput {
    
    func clearList() {
        photos.removeAll()
        totalPhotos = 0
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func appendPhotos(from photos: [Photo], totalPhotos: Int? = nil, isSearch: Bool) {
        self.isSearch = isSearch
        self.photos += photos
        self.totalPhotos = totalPhotos ?? 0
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.photos)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension MainTableManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.item]
        let aspectRatio = CGFloat(photo.width) / CGFloat(photo.height)
        return tableView.frame.width / aspectRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        presenter?.showPhoto(photo: photo)
        generator.impactOccurred()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if photos.count != totalPhotos {
            switch indexPath.row {
            case photos.count - 1:
                presenter?.willDisplay(isSearch: isSearch)
                tableView.tableFooterView = self.createSpinnerFooter()
            default:
                tableView.tableFooterView = nil
            }
        }
    }
}
