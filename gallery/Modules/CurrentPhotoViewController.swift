//
//  CurrentPhotoViewController.swift
//  gallery
//
//  Created by Павел Кривцов on 03.10.2022.
//

import UIKit
import Kingfisher
import SnapKit

protocol CurrentPhotoViewInput: AnyObject {
    func loadPhoto(photo: UIImage, authorName: String)
    func zoom(to rect: CGRect, animated: Bool)
    func showAlert(alert: UIAlertController)
    func trackDownloadProgress(progress: Float)
    func hideProgressView()
    func showProgressView()
    func setTitle(title: String)
    func showInfoAboutPhoto(from view: UIViewController)
}

class CurrentPhotoViewController: UIViewController {
    
    private var presenter: CurrentPhotoViewOutput
    private var scrollView: UIScrollView
    
    private lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomingTap))
        gestureRecognizer.numberOfTapsRequired = 2
        return gestureRecognizer
    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(self.doubleTapRecognizer)
        self.presenter.imageViewForZooming(view: imageView)
        return imageView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.isHidden = true
        return progressView
    }()

    private lazy var infoButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: .init(systemName: "info.circle"),
                                     style: .done,
                                     target: self,
                                     action: #selector(infoButtonTapped))
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
    
    init(presenter: CurrentPhotoViewOutput, scrollView: UIScrollView) {
        self.presenter = presenter
        self.scrollView = scrollView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = infoButton
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(progressView)
        view.addSubview(downloadButton)
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        progressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.width.height.equalToSuperview()
        }
        downloadButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        presenter.loadPhoto()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    @objc
    private func infoButtonTapped() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        presenter.showInfoAboutPhoto()
        generator.impactOccurred()
    }
    
    @objc
    private func downloadButtonTapped() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        self.presenter.downloadPhoto()
        generator.impactOccurred()
    }
    
    @objc
    private func zoomingTap(sender: UITapGestureRecognizer)  {
        let location = sender.location(in: sender.view)
        self.presenter.calculateZoom(from: location)
    }
}

// MARK: - CurrentPhotoViewInput
extension CurrentPhotoViewController: CurrentPhotoViewInput {
    
    func loadPhoto(photo: UIImage, authorName: String) {
        self.title = authorName
        self.imageView.image = photo
    }
    
    func showInfoAboutPhoto(from view: UIViewController) {
        navigationController?.pushViewController(view, animated: true)
    }
    
    func zoom(to rect: CGRect, animated: Bool) {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        self.scrollView.zoom(to: rect, animated: animated)
        generator.impactOccurred()
    }
    
    func trackDownloadProgress(progress: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.progressView.setProgress(progress, animated: true)
            self?.title = "\(Int(progress * 100))%"
        }
    }
    
    func hideProgressView() {
        DispatchQueue.main.async { [weak self] in
            self?.progressView.progress = 0
            self?.progressView.isHidden = true
        }
    }
    
    func setTitle(title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.title = title
        }
    }
    
    func showProgressView() {
        DispatchQueue.main.async { [weak self] in
            self?.progressView.isHidden = false
        }
    }
    
    func showAlert(alert: UIAlertController) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true) {
                alert.dismiss(animated: true)
            }
        }
        generator.notificationOccurred(.success)
    }
}
