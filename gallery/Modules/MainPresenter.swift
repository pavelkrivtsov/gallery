//
//  MainPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit
import Kingfisher

protocol MainTableManagerInput: AnyObject {
    func willDisplay(isSearch: Bool)
    func showPhoto(photo: Photo)
}

protocol SearchManagerInput: AnyObject {
    func loadPhotos()
    func loadPhotos(from text: String)
    func clearList()
}

protocol MainViewOutput: AnyObject {
    func loadPhotos()
}

class MainPresenter {
    
    weak var view: MainViewInput?
    private let networkManager: NetworkManagerOutput
    private let tableManager: MainTableManagerOutput
    private let searchManager: UISearchBarDelegate
    private var imageView = UIImageView()
    private var searchText = String()
    private var resultsPage = 1
    private lazy var noPhotosView = NoPhotosView()
    
    private lazy var alert: UIAlertController = {
        var alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(ok)
        return alert
    }()
   
    init(networkManager: NetworkManagerOutput,
         tableManager: MainTableManagerOutput,
         searchManager: UISearchBarDelegate) {
        self.networkManager = networkManager
        self.tableManager = tableManager
        self.searchManager = searchManager
    }
}

// MARK: - SearchManagerInput, MainViewOutput
extension MainPresenter: SearchManagerInput, MainViewOutput {

    func loadPhotos() {
        networkManager.getPhotos(from: resultsPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self.tableManager.appendPhotos(from: photos, isSearch: false)
                }
            case .failure(let error):
                self.alert.title = error.rawValue
                DispatchQueue.main.async {
                    self.view?.failedLoadPhotos(self.alert)
                    let view = NoPhotosView()
                    self.view?.noFoundPhotos(view)
                }
            }
        }
    }
    
    func loadPhotos(from text: String) {
        searchText = text
        networkManager.getFoundPhotos(from: resultsPage, from: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                if photos.isEmpty {
                    DispatchQueue.main.async {
                        let view = NoPhotosView()
                        self.view?.noFoundPhotos(view)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.tableManager.appendPhotos(from: photos, isSearch: true)
                    }
                }
            case .failure(let error):
                self.alert.title = error.rawValue
                DispatchQueue.main.async {
                    self.view?.failedLoadPhotos(self.alert)
                }
            }
        }
    }
    
    func clearList() {
        resultsPage = 1
        DispatchQueue.main.async {
            self.tableManager.clearList()
            self.view?.removeNoPhotosFromSuperview()
        }
    }
}

// MARK: - MainTableManagerInput
extension MainPresenter: MainTableManagerInput {
    
    func willDisplay(isSearch: Bool) {
        DispatchQueue.global().async {
            KingfisherManager.shared.cache.clearMemoryCache()
            self.resultsPage += 1
            isSearch ? self.loadPhotos(from: self.searchText) : self.loadPhotos()
        }
    }
    
    func showPhoto(photo: Photo) {
        guard let url = URL(string: photo.urls.regular) else { return }
        let photoId = photo.id
        let authorName = photo.user.name ?? ""
    
        imageView.kf.setImage(with: url) { result in
            switch result {
            case .success(_):
                guard let photo = self.imageView.image else { return }
                let detailVC = CurrentPhotoAssembly.assemble(photoId: photoId, photo: photo, authorName: authorName)
                DispatchQueue.main.async {
                    self.view?.showSelectedPhoto(viewController: detailVC)
                }
            case .failure(let error):
                self.alert.title = error.localizedDescription
                DispatchQueue.main.async {
                    self.view?.failedLoadPhotos(self.alert)
                }
            }
        }
    }
}

