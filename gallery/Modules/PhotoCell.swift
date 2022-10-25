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
    private let appearance = Appearance()
    
    private var photo: Photo! {
        didSet {
            let photoURL = photo.urls.regular
            guard let url = URL(string: photoURL) else { return }
            photoView.kf.setImage(with: url)
            authorLabel.text = photo.user.name
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(photoView)
        photoView.frame = contentView.bounds
        photoView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        authorLabel.numberOfLines = 1
        authorLabel.textColor = .white
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(appearance.sideMargin)
            $0.leading.trailing.equalToSuperview().inset(appearance.sideMargin)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoView.image = nil
    }
    
    func configure(photo: Photo){
        self.photo = photo
    }
}
