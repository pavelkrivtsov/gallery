//
//  MainPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func clearList()
    func loadList()
    func loadFoundList(from text: String)
    func willDisplay(isSearch: Bool)
    func showPhoto(photo: Photo)
}

class MainPresenter {
//    weak var view: MainViewControllerProtocol?
    private var networkService: NetworkServiceProtocol
    private var tableManager: MainTableManagerProtocol
    private var router: MainRouterProtocol
    
    private var photos = [Photo]()
    private var currentPage = 1
    private var searchText = ""
    
    init(networkDataFetcher: NetworkServiceProtocol, tableManager: MainTableManager, router: MainRouterProtocol) {
        self.networkService = networkDataFetcher
        self.tableManager = tableManager
        self.router = router
    }
}

extension MainPresenter: MainPresenterProtocol {
    
    func clearList() {
        self.currentPage = 1
        self.tableManager.clearList()
    }
    
    func loadList() {
        self.networkService.getListFromServer(for: self.currentPage) { [weak self] photos in
            guard let self = self, let photos = photos else { return }
            self.tableManager.setList(from: photos, isSearch: self.searchText.isEmpty ? false : true)
        }
    }
    
    func loadFoundList(from text: String) {
        self.searchText = text
        self.networkService.getFoundListFromServer(from: text, for: self.currentPage) { [weak self] searchResults in
            guard let self = self, let searchResults = searchResults else { return }
            self.tableManager.setList(from: searchResults.results, isSearch: self.searchText.isEmpty ? false : true)
        }
    }
    
    func willDisplay(isSearch: Bool) {
        self.currentPage += 1
        isSearch ? self.loadFoundList(from: self.searchText) : self.loadList()
    }
    
    func showPhoto(photo: Photo) {
        router.showPhoto(photo: photo)
    }
}
