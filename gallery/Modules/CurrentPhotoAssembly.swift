//
//  CurrentPhotoAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import UIKit

class CurrentPhotoAssembly {
    static func assemle(photo: Photo) -> UIViewController {
        let networkService = NetworkService()
        let router = CurrentPhotoRouter()
        let presenter = CurrentPhotoPresenter(photo: photo, router: router, networkService: networkService)
        let view = CurrentPhotoViewController(presenter: presenter)
        presenter.view = view
        router.view = view
        return view
    }
}
