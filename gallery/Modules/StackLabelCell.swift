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
    
    private let mainStack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    private let firstlabelStack = LabelStack(frame: .zero)
    private let secondLabelStack = LabelStack(frame: .zero)
    
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

// MARK: - StackLabelCellProtocol
extension StackLabelCell: StackLabelCellProtocol {
    
    public func cellConfiguration(model: CellTypeProtocol) {
        guard let firstTitleLabel = model.labelStack?.firstLabelStackTitle,
              let secondTitleLabel = model.labelStack?.secondLabelStackTitle else { return }
        firstlabelStack.titleLabel.text = firstTitleLabel
        secondLabelStack.titleLabel.text = secondTitleLabel
        firstlabelStack.textLabel.text = model.labelStack?.firstLabelStackText
        secondLabelStack.textLabel.text = model.labelStack?.secondLabelStackText
        firstlabelStack.textLabel.numberOfLines = 0
        secondLabelStack.textLabel.numberOfLines = 0
    }
}
