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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
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
        self.titleLabel.textAlignment = titleLabel.textAlignment
        self.titleLabel.numberOfLines = 0
//        self.titleLabel.backgroundColor = .systemRed
    }
 }
