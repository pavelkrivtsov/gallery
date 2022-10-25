//
//  LabelStack.swift
//  gallery
//
//  Created by Павел Кривцов on 25.10.2022.
//

import UIKit

class LabelStack: UIStackView {
    
    var titleLabel = UILabel()
    var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 5
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        textLabel.font = .systemFont(ofSize: 13, weight: .light)
        addArrangedSubview(titleLabel)
        addArrangedSubview(textLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
