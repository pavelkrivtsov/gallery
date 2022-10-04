//
//  MainAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit

class MainAssembly {
    static func assemle() -> UINavigationController {
        let networkService = NetworkService()
        let router = MainRouter()
        let presenter = MainPresenter(networkDataFetcher: networkService, router: router)
        let view = MainViewController(presenter: presenter)
        presenter.view = view
        router.view = view
        return view.embedInNavigationController()
    }
}
