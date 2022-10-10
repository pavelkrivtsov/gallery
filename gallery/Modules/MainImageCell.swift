//
//  MainImageCell.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import UIKit
import Kingfisher

class MainImageCell: UITableViewCell {
    
    static let cellIdentifier = "ImageCell"
    private let photoImageView = UIImageView()
    
    private var photo: Photo! {
        didSet {
            let photoURL = photo.urls.regular
            guard let url = URL(string: photoURL) else { return }
            photoImageView.kf.setImage(with: url)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
    
    func configure(image: Photo){
        photo = image
    }
    
}
