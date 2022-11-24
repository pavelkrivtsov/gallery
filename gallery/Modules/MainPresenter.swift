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

protocol MainViewOutput: AnyObject {
    func clearList()
    func loadList()
    func loadFoundList(from text: String)
}

class MainPresenter {
    
    weak var view: MainViewInput?
    private let networkService: NetworkServiceOutput
    private let tableManager: MainTableManagerOutput
    private var photos = [Photo]()
    private var currentPage = 1
    private var searchText = ""
    
    init(networkDataFetcher: NetworkServiceOutput, tableManager: MainTableManagerOutput) {
        self.networkService = networkDataFetcher
        self.tableManager = tableManager
    }
}

// MARK: - MainViewOutput
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

// MARK: - MainTableManagerInput
extension MainPresenter: MainTableManagerInput {
    
    func willDisplay(isSearch: Bool) {
        self.currentPage += 1
        isSearch ? self.loadFoundList(from: self.searchText) : self.loadList()
    }

    func showPhoto(photo: Photo) {
        guard let url = URL(string: photo.urls.regular) else { return }
        let photoId = photo.id
        let authorName = photo.user.name ?? ""
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let photo = UIImage(data: data) {
                DispatchQueue.main.async {
                    let detailVC = CurrentPhotoAssembly.assemble(photoId: photoId, photo: photo, authorName: authorName)
                    self?.view?.showCurrentPhoto(viewController: detailVC)
                }
            }
        }
    }
}

