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
    private var resultsPage = 1
    private var searchText = ""
    
    init(networkDataFetcher: NetworkServiceOutput, tableManager: MainTableManagerOutput) {
        self.networkService = networkDataFetcher
        self.tableManager = tableManager
    }
}

// MARK: - MainViewOutput
extension MainPresenter: MainViewOutput {
    
    func clearList() {
        resultsPage = 1
        tableManager.clearList()
    }
    
    func loadList() {
        networkService.getListFromServer(for: resultsPage) { [weak self] photos in
            guard let self = self, let photos = photos else { return }
            self.tableManager.appendPhoros(from: photos, isSearch: self.searchText.isEmpty ? false : true)
        }
    }
    
    func loadFoundList(from text: String) {
        searchText = text
        networkService.getFoundListFromServer(from: text, for: resultsPage) { [weak self] photos in
            guard let self = self, let photos = photos else { return }
            self.tableManager.appendPhoros(from: photos, isSearch: self.searchText.isEmpty ? false : true)
        }
    }
}

// MARK: - MainTableManagerInput
extension MainPresenter: MainTableManagerInput {
    
    func willDisplay(isSearch: Bool) {
        KingfisherManager.shared.cache.clearMemoryCache()
        resultsPage += 1
        isSearch ? loadFoundList(from: searchText) : loadList()
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

