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
        titleLabel.textColor = UIColor(white: 1, alpha: 0.7)
        titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        textLabel.font = .systemFont(ofSize: 13, weight: .regular)
        addArrangedSubview(titleLabel)
        addArrangedSubview(textLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
