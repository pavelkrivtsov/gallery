//
//  NoPhotosView.swift
//  gallery
//
//  Created by Павел Кривцов on 06.12.2022.
//

import UIKit

class NoPhotosView: UIView {
    
    let label = UILabel()
    let imageView = UIImageView(image: .init(systemName: "photo.on.rectangle.angled"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(self.snp.width).dividedBy(2)
        }
        
        addSubview(label)
        label.text = "No photos"
        label.textAlignment = .center
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.width.equalTo(self.snp.width).dividedBy(2)
            $0.centerX.equalTo(imageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
