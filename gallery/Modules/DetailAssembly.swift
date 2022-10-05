//
//  DetailAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 04.10.2022.
//

import UIKit

class DetailAssembly {
    static func assemle(image: UnsplashImage) -> UIViewController {
        let router = DetailRouter()
        let presenter = DetailPresenter(image: image, router: router)
        let view = DetailViewController(presenter: presenter)
        presenter.view = view
        router.view = view
        return view
    }
}
