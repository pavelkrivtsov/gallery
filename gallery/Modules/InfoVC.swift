//
//  InfoVC.swift
//  gallery
//
//  Created by Павел Кривцов on 05.10.2022.
//

import UIKit


class InfoVC: UIViewController {
    
    var image: UnsplashImage
    var label = UILabel()
    
    init(image: UnsplashImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Info"

        view.addSubview(label)
        label.text = image.user.name
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

}
