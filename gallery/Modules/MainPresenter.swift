//
//  MainPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func loadImageList()
    func loadFoundImages(searchText: String)
}

class MainPresenter {
    weak var view: MainViewControllerProtocol?
    var router: MainRouterProtocol
    var networkService: NetworkServiceProtocol
    
    init(networkDataFetcher: NetworkServiceProtocol, router: MainRouterProtocol) {
        self.networkService = networkDataFetcher
        self.router = router
    }
}

extension MainPresenter: MainPresenterProtocol {
    
    func loadImageList() {
        self.networkService.loadImagesList { [weak self] unsplashPhoto in
            guard let self = self, let unsplashPhoto = unsplashPhoto else { return }
            self.view?.setImageList(imageList: unsplashPhoto)
        }
    }
    
    func loadFoundImages(searchText: String) {
        self.networkService.loadFoundImages(from: searchText) { [weak self] searchResults in
            guard let self = self, let searchResults = searchResults else { return }
            self.view?.setImageList(imageList: searchResults.results)
        }
    }
    
}
