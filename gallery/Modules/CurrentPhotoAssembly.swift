//
//  CurrentPhotoAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import UIKit

class CurrentPhotoAssembly {
    static func assemble(photoId: String, photo: UIImage, authorName: String) -> UIViewController {
        let networkService = NetworkService()
        let presenter = CurrentPhotoPresenter(photoId: photoId, photo: photo, authorName: authorName, networkService: networkService)
        let view = CurrentPhotoViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
