//
//  MainRouter.swift
//  gallery
//
//  Created by Павел Кривцов on 03.10.2022.
//

import Foundation

protocol MainRouterProtocol: AnyObject {
    
}

class MainRouter: MainRouterProtocol {
    weak var presenter: MainPresenterProtocol?
}
