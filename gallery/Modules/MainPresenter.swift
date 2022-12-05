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
    private var photos = [Photo]()
    private var searchText = String()
    private var resultsPage = 1
   
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
                self.tableManager.appendPhotos(from: photos, isSearch: false)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadPhotos(from text: String) {
        searchText = text        
        networkManager.getFoundPhotos(from: text, from: resultsPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.tableManager.appendPhotos(from: photos, isSearch: false)
            case .failure(let error):
                print(error)
            }
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

