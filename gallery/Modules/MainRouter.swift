//
//  MainRouter.swift
//  gallery
//
//  Created by Павел Кривцов on 03.10.2022.
//

import UIKit

protocol MainRouterProtocol: AnyObject {
    func showPhoto(photo: Photo)
}

class MainRouter: MainRouterProtocol {
    weak var view: UIViewController?
    
    func showPhoto(photo: Photo) {
        let detailVC = CurrentPhotoAssembly.assemle(photo: photo)
        self.view?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

