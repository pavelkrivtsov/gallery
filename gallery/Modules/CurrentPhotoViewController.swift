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
    func showAlert(_ alert: UIAlertController, notificationType: UINotificationFeedbackGenerator.FeedbackType)
    func trackDownloadProgress(progress: Float)
    func hideProgressView()
    func showProgressView()
    func setTitle(title: String)
    func showInfoAboutPhoto(from view: UIViewController)
    func failedLoadPhoto(_ alert: UIAlertController)
    func enabledInfoButton()
}

class CurrentPhotoViewController: UIViewController {
    
    private var presenter: CurrentPhotoViewOutput
    private var scrollView: UIScrollView
    private lazy var notificationGenerator = UINotificationFeedbackGenerator()
    private lazy var impactGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
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
        button.isEnabled = false
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
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.height.equalToSuperview()
        }
        view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        view.addSubview(downloadButton)
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
        presenter.cancelDownloadTask()
    }
    
    @objc
    private func infoButtonTapped() {
        presenter.showInfoAboutPhoto()
        impactGenerator.impactOccurred()
    }
    
    @objc
    private func downloadButtonTapped() {
        presenter.downloadPhoto()
        impactGenerator.impactOccurred()
    }
    
    @objc
    private func zoomingTap(sender: UITapGestureRecognizer)  {
        let location = sender.location(in: sender.view)
        presenter.calculateZoom(from: location)
    }
}

// MARK: - CurrentPhotoViewInput
extension CurrentPhotoViewController: CurrentPhotoViewInput {
    
    func loadPhoto(photo: UIImage, authorName: String) {
        title = authorName
        imageView.image = photo
    }
    
    func showInfoAboutPhoto(from view: UIViewController) {
        navigationController?.pushViewController(view, animated: true)
    }
    
    func zoom(to rect: CGRect, animated: Bool) {
        scrollView.zoom(to: rect, animated: animated)
        impactGenerator.impactOccurred()
    }
    
    func trackDownloadProgress(progress: Float) {
        progressView.setProgress(progress, animated: true)
        title = "\(Int(progress * 100))%"
    }
    
    func hideProgressView() {
        progressView.progress = 0
        progressView.isHidden = true
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func showProgressView() {
        progressView.isHidden = false
    }
    
    func showAlert(_ alert: UIAlertController, notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        self.present(alert, animated: true) {
            alert.dismiss(animated: true)
        }
        notificationGenerator.notificationOccurred(notificationType)
    }
    
    func failedLoadPhoto(_ alert: UIAlertController) {
        self.present(alert, animated: true)
        notificationGenerator.notificationOccurred(.warning)
    }
    
    func enabledInfoButton() {
        infoButton.isEnabled = true
    }
}
