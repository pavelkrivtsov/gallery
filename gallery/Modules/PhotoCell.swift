//
//  MainImageCell.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit
import Kingfisher
import SnapKit

class PhotoCell: UITableViewCell {
    
    static let cellIdentifier = "PhotoCell"
    private let photoView = UIImageView()
    private var authorLabel = UILabel()
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(photoView)
        photoView.frame = contentView.bounds
        photoView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        authorLabel.numberOfLines = 1
        authorLabel.textColor = .white
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(16)
        }
        
        activityIndicator.startAnimating()
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoView.image = nil
        self.authorLabel.text = ""
        self.activityIndicator.startAnimating()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    
    func configure(photo: Photo){
        let photoURL = photo.urls.regular
        guard let url = URL(string: photoURL) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.photoView.kf.setImage(with: url) { result in
                switch result {
                case .success(_):
                    self?.activityIndicator.stopAnimating()
                case .failure(_):
                    print("self.imageView.kf.setImage(with: url) { failure }")
                }
            }
            self?.authorLabel.text = photo.user.name
        }
    }
}
