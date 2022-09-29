//
//  SearchAssembly.swift
//  gallery
//
//  Created by Павел Кривцов on 29.09.2022.
//

import UIKit

class SearchAssembly {
    static func assemle() -> UINavigationController {
        let networkDataFetcher = NetworkService()
        let presenter = SearchPresenter(networkDataFetcher: networkDataFetcher)
        let view = SearchViewController(presenter: presenter)
        presenter.out = view
        return view.embedInNavigationController()
    }
}
