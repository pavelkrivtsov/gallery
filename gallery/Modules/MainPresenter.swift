//
//  MainPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func loadList(from page: Int)
//    func loadFoundList(searchText: String)
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
    
    func loadList(from page: Int) {
        self.networkService.getListFromServer(page: page) { [weak self] photos in
            guard let self = self, let photos = photos else { return }
            self.view?.setPhotosList(photosList: photos)
        }
    }
    
//    func loadFoundList(searchText: String) {
//        self.networkService.getFoundListFromServer(from: searchText) { [weak self] searchResults in
//            guard let self = self, let searchResults = searchResults else { return }
//            self.view?.setFoundPhotoList(photosList: searchResults.results)
//        }
//    }
    
    func showPhoto(photo: Photo) {
        router.showPhoto(photo: photo)
    }
    
}
