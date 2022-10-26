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
        let detailPhotoInfoVC = DetailPhotoInfoAssembly.assemle(photo: photo)
        self.view?.present(detailPhotoInfoVC, animated: true)
//        self.view?.navigationController?.pushViewController(detailPhotoInfoVC, animated: true)
    }
}
