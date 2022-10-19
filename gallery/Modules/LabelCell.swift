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
 
    public lazy var titleLabel = UILabel()
    public lazy var separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        contentView.addSubview(separator)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        separator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = frame.width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LabelCell: LabelCellProtocol {
    public func cellConfiguration(model: CellTypeProtocol) {
       
        guard let titleLabel = model.titleLabel,
              let separator = model.separator else { return }
      
        self.titleLabel.text = titleLabel.title
        self.titleLabel.textColor = titleLabel.titleColor
        self.titleLabel.font = titleLabel.titleFont
        self.titleLabel.textAlignment = titleLabel.textAlignment
    
        self.separator.isHidden = separator.isHidden
        self.separator.backgroundColor = separator.backgroundColor
        self.backgroundColor = model.general.cellBackgroundColor
    }
 }
