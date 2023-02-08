//
//  MainPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit

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
                self.tableManager.appendPhotos(from: photos, totalPhotos: nil, isSearch: false)
            case .failure(let error):
                self.alert.title = error.rawValue
                self.view?.failedLoadPhotos(self.alert)
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
                    self.view?.noFoundPhotos(self.noPhotosView)
                } else {
                    self.networkManager.getTotalPhotosNumber(from: self.searchText) { totalPhotos in
                        self.tableManager.appendPhotos(from: photos, totalPhotos: totalPhotos, isSearch: true)
                    }
                }
            case .failure(let error):
                self.alert.title = error.rawValue
                self.view?.failedLoadPhotos(self.alert)
            }
        }
    }
    
    func clearList() {
        resultsPage = 1
        self.tableManager.clearList()
        self.view?.removeNoPhotosFromSuperview()
    }
}

// MARK: - MainTableManagerInput
extension MainPresenter: MainTableManagerInput {
    
    func willDisplay(isSearch: Bool) {
        self.resultsPage += 1
        isSearch ? self.loadPhotos(from: self.searchText) : self.loadPhotos()
    }
    
    func showPhoto(photo: Photo) {
        guard let url = URL(string: photo.urls.regular) else { return }
        let photoId = photo.id
        let authorName = photo.user.name ?? ""
        
        networkManager.downloadImage(url: url) { result in
            switch result {
            case .success(let image):
                let detailVC = PhotoViewAssembly.assemble(photoId: photoId, photo: image, authorName: authorName)
                self.view?.showSelectedPhoto(viewController: detailVC)
            case .failure(let error):
                self.alert.title = error.localizedDescription
                self.view?.failedLoadPhotos(self.alert)
            }
        }
    }
}

