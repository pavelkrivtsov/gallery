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
    var appearance = Appearance()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = appearance.labelStackSpacing
        titleLabel.font = .systemFont(ofSize: appearance.labelStackFontSize, weight: .medium)
        textLabel.font = .systemFont(ofSize: appearance.labelStackFontSize, weight: .light)
        addArrangedSubview(titleLabel)
        addArrangedSubview(textLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
