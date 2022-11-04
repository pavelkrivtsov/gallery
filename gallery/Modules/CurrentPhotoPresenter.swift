//
//  CurrentPhotoPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import UIKit

protocol CurrentPhotoPresenterProtocol: AnyObject {
    func loadPhoto()
    func showInfoAboutPhoto()
    func downloadPhoto(photo: Photo)
}

class CurrentPhotoPresenter {
    weak var view: CurrentPhotoViewControllerProtocol?
    private var networkService: NetworkServiceProtocol
    private var router: CurrentPhotoRouterProtocol
    private var photo: Photo
    
    init(photo: Photo, router: CurrentPhotoRouterProtocol, networkService: NetworkServiceProtocol) {
        self.photo = photo
        self.router = router
        self.networkService = networkService
    }
}

extension CurrentPhotoPresenter: CurrentPhotoPresenterProtocol {
    
    func loadPhoto() {
        self.networkService.getCurrentPhoto(by: self.photo.id) { [weak self] photo in
            guard let self = self, let photo = photo else { return }
            self.photo = photo
            self.view?.loadPhoto(photo: photo)
        }
    }
    
    func showInfoAboutPhoto() {
        router.showInfo(from: self.photo)
    }
    
    func downloadPhoto(photo: Photo) {
        self.view?.startActivityIndicator()
        networkService.downloadPhoto(photo: photo) { data in
            guard let photo = UIImage(data: data) else { return }
            UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
            self.view?.stopActivityIndicator()
            self.view?.showAlert()
        }
    }
    
}
