//
//  TabBarViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 29.09.2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .white
        viewControllers = [
            MainAssembly.assemle(),
            SearchAssembly.assemle()
        ]
    }

}
