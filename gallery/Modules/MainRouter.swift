//
//  MainRouter.swift
//  gallery
//
//  Created by Павел Кривцов on 03.10.2022.
//

import Foundation

protocol MainRouterProtocol: AnyObject {
    func showImage(image: Photo)
}

class MainRouter: MainRouterProtocol {

    weak var view: MainViewController?
    
    func showImage(image: Photo) {
        let detailVC = DetailAssembly.assemle(image: image)
        self.view?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

