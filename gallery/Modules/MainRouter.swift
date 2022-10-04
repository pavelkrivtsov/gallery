//
//  MainRouter.swift
//  gallery
//
//  Created by Павел Кривцов on 03.10.2022.
//

import Foundation

protocol MainRouterProtocol: AnyObject {
    func showImage(image: UnsplashImage)
}

class MainRouter: MainRouterProtocol {

    weak var view: MainViewController?
    
    func showImage(image: UnsplashImage) {
        let detailVC = DetailAssembly.assemle(image: image)
        self.view?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

