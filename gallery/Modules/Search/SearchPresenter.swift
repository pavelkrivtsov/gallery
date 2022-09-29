//
//  SearchPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 29.09.2022.
//

import Foundation

protocol SearchPresenterIn: AnyObject {
    func setupImageList()
    func fetchSearchigImages(searchText: String)
}

protocol SearchPresenterOut: AnyObject {
    func setImageList(imageList: [UnsplashImage])
}

class SeachPresenter {
    weak var out: SearchPresenterOut?
    var networkDataFetcher: NetworkService
    
    init(networkDataFetcher: NetworkService) {
        self.networkDataFetcher = networkDataFetcher
    }
}

extension SeachPresenter: SearchPresenterIn {
    
    func setupImageList() {
        self.networkDataFetcher.fetchImagesList { [weak self] unsplashPhoto in
            guard let self = self, let unsplashPhoto = unsplashPhoto else { return }
            self.out?.setImageList(imageList: unsplashPhoto)
        }
    }
    
    func fetchSearchigImages(searchText: String) {
        self.networkDataFetcher.fetchSearchigImages(searchText: searchText) { [weak self] searchResults in
            guard let self = self, let searchResults = searchResults else { return }
            self.out?.setImageList(imageList: searchResults.results)
        }
    }
    
}
