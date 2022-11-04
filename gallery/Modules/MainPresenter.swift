//
//  MainPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func loadList(for page: Int)
    func loadFoundList(from text: String, for page: Int)
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
    
    func loadList(for page: Int) {
        self.networkService.getListFromServer(for: page) { [weak self] photos in
            guard let self = self, let photos = photos else { return }
            self.view?.setList(from: photos)
        }
    }
    
    func loadFoundList(from text: String, for page: Int) {
        self.networkService.getFoundListFromServer(from: text, for: page) { [weak self] searchResults in
            guard let self = self, let searchResults = searchResults else { return }
            self.view?.setList(from: searchResults.results)
        }
    }
    
    func showPhoto(photo: Photo) {
        router.showPhoto(photo: photo)
    }
}
