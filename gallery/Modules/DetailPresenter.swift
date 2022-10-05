//
//  DetailPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    func loadImage()
    func showInfoAboutImage()
}

class DetailPresenter {
    weak var view: DetailViewControllerProtocol?
    private var router: DetailRouterProtocol
    private var image: UnsplashImage
    
    init(image: UnsplashImage, router: DetailRouterProtocol) {
        self.image = image
        self.router = router
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func loadImage() {
        view?.loadImage(image: self.image)
    }
    
    func showInfoAboutImage() {
        router.showInfo(from: image)
    }
}
