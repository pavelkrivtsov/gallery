//
//  StackLabelCell.swift
//  gallery
//
//  Created by Павел Кривцов on 24.10.2022.
//

import UIKit
import SnapKit

protocol StackLabelCellProtocol {
    func cellConfiguration(model: CellTypeProtocol)
}

class StackLabelCell: UITableViewCell {
 
    lazy var mainStack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    lazy var firstlabelStack = LabelStack(frame: .zero)
    lazy var secondLabelStack = LabelStack(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainStack)
        mainStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.top.equalToSuperview().inset(8)
        }
        mainStack.addArrangedSubview(firstlabelStack)
        mainStack.addArrangedSubview(secondLabelStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StackLabelCell: StackLabelCellProtocol {
    public func cellConfiguration(model: CellTypeProtocol) {
        guard let firstTitleLabel = model.labelStack?.firstLabelStackTitle,
        let secondTitleLabel = model.labelStack?.secondLabelStackTitle else { return }
        self.firstlabelStack.titleLabel.text = firstTitleLabel
        self.secondLabelStack.titleLabel.text = secondTitleLabel
        self.firstlabelStack.textLabel.text = model.labelStack?.firstLabelStackText
        self.secondLabelStack.textLabel.text = model.labelStack?.secondLabelStackText
        self.firstlabelStack.textLabel.numberOfLines = 0
        self.secondLabelStack.textLabel.numberOfLines = 0
    }
 }
