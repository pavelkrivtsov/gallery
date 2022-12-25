//
//  MainImageCell.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit
import SnapKit

class PhotoCell: UITableViewCell {
    
    static let cellIdentifier = "PhotoCell"
    private let photoView = UIImageView()
    private let authorLabel = UILabel()
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    private let networkManager = NetworkManager()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(photoView)
        photoView.frame = contentView.bounds
        photoView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        contentView.addSubview(authorLabel)
        authorLabel.numberOfLines = 1
        authorLabel.textColor = .white
        authorLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(16)
        }
        
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
        photoView.image = nil
        authorLabel.text = ""
    }
    
    func configure(photo: Photo){
        self.activityIndicator.startAnimating()
        DispatchQueue.global().async {
            let photoURL = photo.urls.regular
            guard let url = URL(string: photoURL) else { return }
            self.networkManager.downloadImage(url: url) { image in
                DispatchQueue.main.async {
                    self.photoView.image = image
                    self.authorLabel.text = photo.user.name
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
