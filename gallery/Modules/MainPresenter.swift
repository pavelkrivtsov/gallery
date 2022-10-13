//
//  MainPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func loadPhotosList()
    func loadFoundPhotos(searchText: String)
    func showPhoto(photo: Photo)
}

class MainPresenter {
    weak var view: MainViewControllerProtocol?
    private var router: MainRouterProtocol
    private var networkService: NetworkServiceProtocol
    
    init(networkDataFetcher: NetworkServiceProtocol, router: MainRouterProtocol) {
        self.networkService = networkDataFetcher
        self.router = router
    }
}

extension MainPresenter: MainPresenterProtocol {
    
    func loadPhotosList() {
        self.networkService.loadPhotosList { [weak self] photo in
            guard let self = self, let photo = photo else { return }
            self.view?.setPhotosList(photosList: photo)
        }
    }
    
    func loadFoundPhotos(searchText: String) {
        self.networkService.loadFoundPhotos(from: searchText) { [weak self] searchResults in
            guard let self = self, let searchResults = searchResults else { return }
            self.view?.setPhotosList(photosList: searchResults.results)
        }
    }
    
    func showPhoto(photo: Photo) {
        router.showPhoto(photo: photo)
    }
    
}
