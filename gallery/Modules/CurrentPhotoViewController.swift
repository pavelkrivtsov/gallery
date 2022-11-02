//
//  CurrentPhotoViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 03.10.2022.
//

import UIKit
import Kingfisher
import SnapKit

protocol CurrentPhotoViewControllerProtocol: AnyObject {
    func loadPhoto(photo: Photo)
    func startActivityIndicator()
    func stopActivityIndicator()
    func showAlert()
}

class CurrentPhotoViewController: UIViewController {
    private var presenter: CurrentPhotoPresenterProtocol

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        return activityIndicator
    }()
    
    private lazy var infoButton: UIButton = {
        var button = UIButton()
        var config = UIButton.Configuration.bordered()
        config.image = .init(systemName: "info")
        button.configuration = config
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var downloadButton: UIButton = {
        var button = UIButton()
        var config = UIButton.Configuration.bordered()
        config.image = .init(systemName: "arrow.down")
        button.configuration = config
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        return button
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
    
    init(presenter: CurrentPhotoPresenterProtocol) {
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
        addSubviews()
        setupNavigationBar()
        
        presenter.loadPhoto()
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
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.init(named: "AccentColor")
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(downloadButton)
        view.addSubview(infoButton)
        view.addSubview(activityIndicator)
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        imageView.snp.makeConstraints { $0.leading.trailing.top.bottom.width.height.equalToSuperview() }
        activityIndicator.snp.makeConstraints { $0.centerX.centerY.equalToSuperview() }
        
        downloadButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        infoButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-16)
            $0.centerY.equalTo(downloadButton.snp.centerY)
        }
    }
    
    @objc
    private func handleZoomingTap(sender: UITapGestureRecognizer)  {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
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
    
    private func zoomRect(scale: CGFloat, center: CGPoint ) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.scrollView.bounds
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height  / 2)
        return zoomRect
    }
    
    @objc
    private func infoButtonTapped() {
        presenter.showInfoAboutPhoto()
    }
    
    @objc
    private func downloadButtonTapped() {
        presenter.downloadPhoto(photo: self.photo)
    }
    
    private func configure(photo: Photo) {
        self.photo = photo
    }
}

extension CurrentPhotoViewController: UIScrollViewDelegate {
    
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

extension CurrentPhotoViewController: CurrentPhotoViewControllerProtocol {
   
    func loadPhoto(photo: Photo) {
        self.configure(photo: photo)
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Saved", message: nil, preferredStyle: .alert)
            let okACtion = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okACtion)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
