//
//  CurrentPhotoAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import UIKit

class CurrentPhotoAssembly {
    static func assemble(photo: Photo) -> UIViewController {
        let networkService = NetworkService()
        let presenter = CurrentPhotoPresenter(photo: photo, networkService: networkService)
        let view = CurrentPhotoViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
