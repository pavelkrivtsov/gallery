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
    private var detailPhotoInfo: Photo?
    
    private var photoId = ""
    private var photo = UIImage()
    private var authorName = ""
    

//    init(photo: Photo, networkService: NetworkServiceOutput) {
//        self.photo = photo
//        self.networkService = networkService
//    }
    
    init(photoId: String, photo: UIImage, authorName: String, networkService: NetworkServiceOutput) {
        self.photo = photo
        self.photoId = photoId
        self.authorName = authorName
        self.networkService = networkService
    }
}

extension CurrentPhotoPresenter: CurrentPhotoViewOutput {
    
    func loadPhoto() {
        self.view?.loadPhoto(photo: self.photo, authorName: self.authorName)
        self.networkService.getCurrentPhoto(by: self.photoId) { [weak self] photo in
            guard let self = self,
                  let photo = photo else { return }
            self.detailPhotoInfo = photo
        }
    }
    
    func showInfoAboutPhoto() {
        let detailPhotoInfoVC = DetailPhotoInfoAssembly.assemble(from: self.detailPhotoInfo!)
        self.view?.showInfoAboutPhoto(from: detailPhotoInfoVC)
    }
    
    func downloadPhoto() {
        self.view?.showProgressView()
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)
        networkService.downloadPhoto(session: session, photo: self.detailPhotoInfo!)
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
        self.view?.setTitle(title: self.detailPhotoInfo?.user.name ?? "")
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
