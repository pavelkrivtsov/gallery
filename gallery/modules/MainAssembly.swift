//
//  MainAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit

class MainAssembly {
    static func assemle() -> UINavigationController {
        let networkDataFetcher = NetworkService()
        let presenter = MainPresenter(networkDataFetcher: networkDataFetcher)
        let view = MainViewController(presenter: presenter)
        presenter.out = view
        return view.embedInNavigationController()
    }
}
