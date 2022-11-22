//
//  MainPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit
import Kingfisher

class MainPresenter {
    
    weak var view: MainViewInput?
    private var networkService: NetworkServiceOutput
    private var tableManager: MainTableManagerOutput
    private var photos = [Photo]()
    private var currentPage = 1
    private var searchText = ""
    
    init(networkDataFetcher: NetworkServiceOutput, tableManager: MainTableManagerOutput) {
        self.networkService = networkDataFetcher
        self.tableManager = tableManager
    }
}

extension MainPresenter: MainViewOutput {
    
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
}

extension MainPresenter: MainTableManagerInput {
    
    func willDisplay(isSearch: Bool) {
        self.currentPage += 1
        isSearch ? self.loadFoundList(from: self.searchText) : self.loadList()
    }

    func showPhoto(photo: Photo) {
        let detailVC = CurrentPhotoAssembly.assemble(photo: photo)
        view?.showCurrentPhoto(viewController: detailVC)
    }
}

