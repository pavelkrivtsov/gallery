//
//  MainPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import Foundation

protocol MainPresenterIn: AnyObject {
    func setupImageList()
}

protocol MainPresenterOut: AnyObject {
    func setImageList(imageList: [UnsplashImage])
}

class MainPresenter {
    weak var out: MainPresenterOut?
    var networkDataFetcher: NetworkService
    
    init(networkDataFetcher: NetworkService) {
        self.networkDataFetcher = networkDataFetcher
    }
}

extension MainPresenter: MainPresenterIn {
    
    func setupImageList() {
        self.networkDataFetcher.fetchImagesList { [weak self] unsplashPhoto in
            guard let self = self, let unsplashPhoto = unsplashPhoto else { return }
            self.out?.setImageList(imageList: unsplashPhoto)
        }
    }

}
