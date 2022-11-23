//
//  CurrentPhotoAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import UIKit

class CurrentPhotoAssembly {
    static func assemble(photoId: String, photo: UIImage, authorName: String) -> UIViewController {
        
        let scrollView = UIScrollView()
        let photoZoomManager = PhotoZoomManager(scrollView: scrollView)
        let networkService = NetworkService()
        let presenter = CurrentPhotoPresenter(photoId: photoId,
                                              photo: photo,
                                              authorName: authorName,
                                              networkService: networkService,
                                              photoZoomMAnager: photoZoomManager)
        let view = CurrentPhotoViewController(presenter: presenter, scrollView: scrollView)
        photoZoomManager.presenter = presenter
        presenter.view = view
        return view
    }
}
