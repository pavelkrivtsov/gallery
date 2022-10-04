//
//  DetailViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 03.10.2022.
//

import UIKit
import Kingfisher

protocol DetailViewControllerProtocol: AnyObject {
    func loadImage(image: UnsplashImage)
}

class DetailViewController: UIViewController {
    
    private var presenter: DetailPresenterProtocol
    private var imageView = UIImageView()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var unsplashImage: UnsplashImage! {
        didSet {
            let photoURL = unsplashImage.urls["full"]
            guard let photoURL = photoURL,
                  let url = URL(string: photoURL) else { return }
            imageView.kf.setImage(with: url)
        }
    }
    
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        presenter.loadImage()
    }
    
    override func viewWillLayoutSubviews() {
        imageView.image == nil ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    private func configure(image: UnsplashImage) {
        unsplashImage = image
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    func loadImage(image: UnsplashImage) {
        self.configure(image: image)
    }
}
