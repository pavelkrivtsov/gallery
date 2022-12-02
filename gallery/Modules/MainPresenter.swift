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
    private let networkService: NetworkServiceOutput
    private let tableManager: MainTableManagerOutput
    private let searchManager: UISearchBarDelegate
    private var imageView = UIImageView()
    private var photos = [Photo]()
    private var searchText = String()
    private var resultsPage = 1
   
    init(networkDataFetcher: NetworkServiceOutput,
         tableManager: MainTableManagerOutput,
         searchManager: UISearchBarDelegate) {
        self.networkService = networkDataFetcher
        self.tableManager = tableManager
        self.searchManager = searchManager
    }
}

// MARK: - SearchManagerInput, MainViewOutput
extension MainPresenter: SearchManagerInput, MainViewOutput {

    func loadPhotos() {
        networkService.getPhotos(from: resultsPage) { [weak self] photos in
            guard let self = self, let photos = photos else { return }
            self.tableManager.appendPhotos(from: photos, isSearch: false)
        }
    }
    
    func loadPhotos(from text: String) {
        searchText = text
        networkService.getFoundPhotos(from: text, from: resultsPage) { [weak self] photos in
            guard let self = self, let photos = photos else { return }
            self.tableManager.appendPhotos(from: photos, isSearch: true)
        }
    }
    
    func clearList() {
        resultsPage = 1
        tableManager.clearList()
    }
}

// MARK: - MainTableManagerInput
extension MainPresenter: MainTableManagerInput {
    
    func willDisplay(isSearch: Bool) {
        KingfisherManager.shared.cache.clearMemoryCache()
        resultsPage += 1
        isSearch ? loadPhotos(from: searchText) : loadPhotos()
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
                    self.view?.showCurrentPhoto(viewController: detailVC)
                }
            case .failure(_):
                print("self.imageView.kf.setImage(with: url) { failure }")
            }
        }
    }
}

