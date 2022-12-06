//
//  CurrentPhotoPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import UIKit

protocol CurrentPhotoViewOutput: AnyObject {
    func loadPhoto()
    func calculateZoom(from point: CGPoint)
    func showInfoAboutPhoto()
    func downloadPhoto()
    func imageViewForZooming(view: UIImageView)
    func cancelDownloadTask()
}

protocol PhotoZoomManagerInput: AnyObject {
    func getZoomRect(rect: CGRect)
}

protocol NetworkServiceInput: AnyObject {
    func savePhoto(from data: Data)
    func trackDownloadProgress(progress: Float)
    func failedDownloadPhoto()
}

class CurrentPhotoPresenter: NSObject {
    
    weak var view: CurrentPhotoViewInput?
    private let photoZoomManager: PhotoZoomManagerOutput
    private let networkManager: NetworkManagerOutput
    private var detailPhotoInfo: Photo?
    private var photoId = ""
    private var photo = UIImage()
    private var authorName = ""
    private lazy var alert: UIAlertController = {
        var alert = UIAlertController(title: "Failed load photo",
                                      message: nil,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(ok)
        return alert
    }()
    
    private lazy var downloadAlert: UIAlertController = {
        let alert = UIAlertController(title: "",
                                      message: nil,
                                      preferredStyle: .alert)
        let imageView = UIImageView(image: .init(systemName: "square.and.arrow.down"))
        let alertSize = 75
        alert.view.addSubview(imageView)
        alert.view.snp.makeConstraints {
            $0.size.equalTo(alertSize)
        }
        imageView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.size.equalTo(alertSize / 2)
        }
        return alert
    }()
    
    private lazy var failedDownloadAlert: UIAlertController = {
        let alert = UIAlertController(title: "Failed download photo",
                                      message: nil,
                                      preferredStyle: .alert)
        return alert
    }()
    
    init(photoId: String,
         photo: UIImage,
         authorName: String,
         networkManager: NetworkManagerOutput,
         photoZoomMAnager: PhotoZoomManagerOutput) {
        self.photo = photo
        self.photoId = photoId
        self.authorName = authorName
        self.networkManager = networkManager
        self.photoZoomManager = photoZoomMAnager
    }
}

// MARK: - CurrentPhotoViewOutput
extension CurrentPhotoPresenter: CurrentPhotoViewOutput {
    
    func loadPhoto() {
        networkManager.getSelectedPhoto(by: photoId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photo):
                self.detailPhotoInfo = photo
            case .failure(_):
                DispatchQueue.main.async {
                    self.view?.failedLoadPhoto(self.alert)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.view?.loadPhoto(photo: self.photo, authorName: self.authorName)
        }
    }
    
    func calculateZoom(from point: CGPoint) {
        photoZoomManager.calculateZoom(from: point)
    }
    
    func imageViewForZooming(view: UIImageView) {
        photoZoomManager.setImageView(view: view)
    }
    
    func showInfoAboutPhoto() {
        guard let detailPhotoInfo = self.detailPhotoInfo else { return }
        let detailPhotoInfoVC = DetailPhotoInfoAssembly.assemble(from: detailPhotoInfo)
        DispatchQueue.main.async {
            self.view?.showInfoAboutPhoto(from: detailPhotoInfoVC)
        }
    }
    
    func downloadPhoto() {
        guard let detailPhotoInfo = self.detailPhotoInfo else { return }
        DispatchQueue.main.async {
            self.view?.showProgressView()
        }
        networkManager.downloadPhoto(photo: detailPhotoInfo)
    }
    
    func cancelDownloadTask() {
        networkManager.cancelDownloadTask()
    }
}

// MARK: - NetworkServiceInput
extension CurrentPhotoPresenter: NetworkServiceInput {
        
    func trackDownloadProgress(progress: Float) {
        DispatchQueue.main.async {
            self.view?.trackDownloadProgress(progress: progress)
        }
    }
    
    func savePhoto(from data: Data) {
        if let photo = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
            DispatchQueue.main.async {
                self.view?.hideProgressView()
                self.view?.setTitle(title: self.detailPhotoInfo?.user.name ?? "")
                self.view?.showAlert(self.downloadAlert, notificationType: .success)
            }
        }
    }
    
    func failedDownloadPhoto() {
        DispatchQueue.main.async {
            self.view?.showAlert(self.failedDownloadAlert, notificationType: .error)
        }
    }
}

// MARK: - PhotoZoomManagerInput
extension CurrentPhotoPresenter: PhotoZoomManagerInput {
    func getZoomRect(rect: CGRect) {
        DispatchQueue.main.async {
            self.view?.zoom(to: rect, animated: true)
        }
    }
}
