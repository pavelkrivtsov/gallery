//
//  CurrentPhotoPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import UIKit

class CurrentPhotoPresenter: NSObject {
    
    weak var view: CurrentPhotoViewInput?
    private var networkService: NetworkServiceOutput
    private var photo: Photo
    
    init(photo: Photo, networkService: NetworkServiceOutput) {
        self.photo = photo
        self.networkService = networkService
    }
}

extension CurrentPhotoPresenter: CurrentPhotoViewOutput {
    
    func loadPhoto() {
        self.view?.startActivityIndicator()
        self.networkService.getCurrentPhoto(by: self.photo.id) { [weak self] photo in
            guard let self = self, let photo = photo else { return }
            self.photo = photo
            self.view?.loadPhoto(photo: photo)
        }
    }
    
    func showInfoAboutPhoto() {
        let detailPhotoInfoVC = DetailPhotoInfoAssembly.assemble(from: photo)
        self.view?.showInfoAboutPhoto(from: detailPhotoInfoVC)
    }
    
    func downloadPhoto() {
        self.view?.showProgressView()
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)
        networkService.downloadPhoto(session: session, photo: self.photo)
    }
}

extension CurrentPhotoPresenter: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location), let photo = UIImage(data: data) else {
            print("The data could be loaded")
            return
        }
        UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
        self.view?.hideProgressView()
        self.view?.setTitle(title: self.photo.user.name ?? "")
        self.view?.showAlert()
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        self.view?.trackDownloadProgress(progress: progress)
    }
}
