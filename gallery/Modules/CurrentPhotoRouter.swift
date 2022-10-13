//
//  CurrentPhotoRouter.swift
//  gallery
//
//  Created by Павел Кривцов on 05.10.2022.
//

import UIKit

protocol CurrentPhotoRouterProtocol: AnyObject {
    func showInfo(from photo: Photo)
}

class CurrentPhotoRouter: CurrentPhotoRouterProtocol {
    weak var view: UIViewController?
    
    func showInfo(from photo: Photo) {
        let infoVC = DetailInfoViewController(photo: photo)
//        let navigationController = UINavigationController(rootViewController: infoVC)
//        infoVC.modalPresentationStyle = .fullScreen
        view?.present(infoVC, animated: true)
    }
}
