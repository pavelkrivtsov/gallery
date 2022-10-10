//
//  DetailViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 03.10.2022.
//

import UIKit
import Kingfisher

protocol DetailViewControllerProtocol: AnyObject {
    func loadImage(image: Photo)
}

class DetailViewController: UIViewController {
    
    private var presenter: DetailPresenterProtocol
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private var photo: Photo! {
        didSet {
            let photoURL = photo.urls.full
            guard let url = URL(string: photoURL) else { return }
            imageView.kf.setImage(with: url)
            title = photo.user.name
        }
    }
    
    private var gestureRecognizer: UITapGestureRecognizer = {
        var gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.numberOfTapsRequired = 2
        return gestureRecognizer
    }()
    
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
        scrollView.delegate = self
        gestureRecognizer.addTarget(self, action: #selector(handleZoomingTap))
        imageView.addGestureRecognizer(self.gestureRecognizer)
        imageView.isUserInteractionEnabled = true
        setupNavigationBar()
        addSubviews()
        
        presenter.loadImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.image == nil ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.init(named: "AccentColor")
        let infoButton = UIBarButtonItem(image: .init(systemName: "info.circle"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(infoButtonTapped))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        scrollView.addSubview(imageView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.heightAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    @objc
    func handleZoomingTap(sender: UITapGestureRecognizer)  {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }
    
    func zoom(point: CGPoint, animated: Bool) {
        let currentScale = self.scrollView.zoomScale
        let minScale = self.scrollView.minimumZoomScale
        let maxScale = self.scrollView.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currentScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale , center: point)
        self.scrollView.zoom(to: zoomRect, animated: animated)
    }
    
    func zoomRect(scale: CGFloat, center: CGPoint ) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.scrollView.bounds
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height  / 2)
        return zoomRect
    }
    
    @objc
    func infoButtonTapped() {
        presenter.showInfoAboutImage()
    }
    
    private func configure(image: Photo) {
        photo = image
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioWidth = imageView.frame.width / image.size.width
                let ratioHeight = imageView.frame.height / image.size.height
                
                let ratio = ratioWidth < ratioHeight ? ratioWidth : ratioHeight
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width :
                                    (scrollView.frame.width - scrollView.contentSize.width))
                let conditionTop = newHeight * scrollView.zoomScale > imageView.frame.height
                let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height :
                                    (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = .init(top: top, left: left ,bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
    
}

extension DetailViewController: DetailViewControllerProtocol {
    func loadImage(image: Photo) {
        self.configure(image: image)
    }
}
