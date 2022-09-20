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
    func setImageList(imageList: [UnsplashPhoto])
}

class MainPresenter {
    weak var out: MainPresenterOut?
    var networkDataFetcher: NetworkService
    
    init(networkDataFetcher: NetworkService) {
        self.networkDataFetcher = networkDataFetcher
    }
    
    func setupImageList() {
        self.networkDataFetcher.fetchImagesList { [weak self] unsplashPhoto in
            guard let self = self, let unsplashPhoto = unsplashPhoto else { return }
            self.out?.setImageList(imageList: unsplashPhoto)
        }
    }
}

extension MainPresenter: MainPresenterIn {
    func viewDidLoad() {
        setupImageList()
    }
}
