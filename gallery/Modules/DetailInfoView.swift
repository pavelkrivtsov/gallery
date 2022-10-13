//
//  DetailInfoView.swift
//  gallery
//
//  Created by Павел Кривцов on 11.10.2022.
//

import UIKit

class DetailInfoView: UIView {
    
    private var descriptionLabel = UILabel()
    private var separatorView = UIView()
    private let cameraLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        
        descriptionLabel.text = "asdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnjaasdjknbvbd'bvjnadb'kajdrnv'dfjklvnadf;jkvnad'kjvndk'jvnfjnvjfnvjfnvjnfjvnfjnvjfnvjnfjvnfjvnfjvnfjvnja"
        descriptionLabel.numberOfLines = 0
        self.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        separatorView.backgroundColor = .red
        self.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
    
        cameraLabel.text = "Camera"
        self.addSubview(cameraLabel)
        cameraLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
           
            cameraLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            cameraLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cameraLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension DetailInfoView {
    
}
