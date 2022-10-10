//
//  DetailPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    func loadPhoto()
    func showInfoAboutPhoto()
}

class DetailPresenter {
    weak var view: DetailViewControllerProtocol?
    private var networkService: NetworkServiceProtocol
    private var router: DetailRouterProtocol
    private var image: Photo
    
    init(image: Photo, router: DetailRouterProtocol, networkService: NetworkServiceProtocol) {
        self.image = image
        self.router = router
        self.networkService = networkService
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    
    func loadPhoto() {
        self.networkService.loadCurrentPhoto(by: self.image.id) { [weak self] photo in
            guard let self = self, let photo = photo else { return }
            self.view?.loadImage(image: photo)
        }
    }
    
    func showInfoAboutPhoto() {
        router.showInfo(from: image)
    }
}
