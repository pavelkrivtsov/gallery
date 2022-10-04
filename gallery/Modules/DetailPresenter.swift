//
//  DetailPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    func loadImage()
}

class DetailPresenter {
    weak var view: DetailViewControllerProtocol?
    private var image: UnsplashImage
    
    init(view: DetailViewControllerProtocol? = nil, image: UnsplashImage) {
        self.view = view
        self.image = image
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func loadImage() {
        view?.loadImage(image: self.image)
    }
}
