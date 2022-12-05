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
        let networkManager = NetworkManager()
        let presenter = CurrentPhotoPresenter(photoId: photoId,
                                              photo: photo,
                                              authorName: authorName,
                                              networkManager: networkManager,
                                              photoZoomMAnager: photoZoomManager)
        let view = CurrentPhotoViewController(presenter: presenter, scrollView: scrollView)
        networkManager.presenter = presenter
        photoZoomManager.presenter = presenter
        presenter.view = view
        return view
    }
}
