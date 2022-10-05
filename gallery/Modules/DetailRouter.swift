//
//  DetailRouter.swift
//  gallery
//
//  Created by Павел Кривцов on 05.10.2022.
//

import UIKit

protocol DetailRouterProtocol: AnyObject {
    func showInfo(from image: UnsplashImage)
}

class DetailRouter: DetailRouterProtocol {
    
    weak var view: DetailViewController?
    
    func showInfo(from image: UnsplashImage) {
        let infoVC = InfoVC(image: image)
        let navigationController = UINavigationController(rootViewController: infoVC)
        view?.present(navigationController, animated: true)
    }
    
}
