//
//  LabelCell.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit
import SnapKit

protocol LabelCellProtocol {
    func cellConfiguration(model: CellTypeProtocol)
}

class LabelCell: UITableViewCell {
 
    lazy var titleLabel = UILabel()
    lazy var separator = UIView(frame: .zero)
    lazy var appearance = Appearance()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(appearance.sideMargin)
        }
        contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.bottom).offset(appearance.sideMargin)
            $0.leading.trailing.equalToSuperview().inset(appearance.sideMargin)
            $0.height.equalTo(1)
        }
        separator.backgroundColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LabelCell: LabelCellProtocol {
    public func cellConfiguration(model: CellTypeProtocol) {
        guard let titleLabel = model.label else { return }
        self.titleLabel.text = titleLabel.title
        self.titleLabel.font = titleLabel.titleFont
        self.titleLabel.textAlignment = titleLabel.titleAligment
        self.titleLabel.numberOfLines = 0
        self.separator.isHidden = titleLabel.separatorIsHidden
        self.titleLabel.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(appearance.sideMargin)
            $0.bottom.equalToSuperview().inset(titleLabel.bottomSideMargin)
        }
    }
 }
