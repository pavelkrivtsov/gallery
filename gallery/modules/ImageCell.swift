//
//  ImageCell.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit
import Kingfisher

class ImageCell: UITableViewCell {
    
    static let cellIdentifier = "ImageCell"
    let descriptionLabel = UILabel()
    let userNameLabel = UILabel()
    let photoImageView = UIImageView()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoURL = unsplashPhoto.urls["regular"]
            guard let photoURL = photoURL, let url = URL(string: photoURL) else { return }
            photoImageView.kf.setImage(with: url)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImageView()
        setupDescriptionLabel()
        setupUserNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
    
    private func setupImageView() {
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = ""
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .init(name: "Avenir-Medium", size: 15)
        descriptionLabel.numberOfLines = 2
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -5),
            descriptionLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -5)
        ])
    }
    
    private func setupUserNameLabel() {
        userNameLabel.textColor = .white
        userNameLabel.textAlignment = .left
        userNameLabel.font = .init(name: "Avenir-Medium", size: 17)
        userNameLabel.numberOfLines = 1
        contentView.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor)
        ])
    }
    
    func configure(image: UnsplashPhoto){
        unsplashPhoto = image
        descriptionLabel.text = image.description
        userNameLabel.text = "\(unsplashPhoto.user.name)"
    }
    
}
