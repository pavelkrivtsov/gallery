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
       
        guard let label = model.label,
              let separatorStyle = model.separator else { return }
      
        titleLabel.text = label.title
        titleLabel.textColor = label.titleColor
        titleLabel.font = label.titleFont
        titleLabel.textAlignment = label.textAlignment
    
        separator.isHidden = separatorStyle.isHidden
        self.backgroundColor = model.general.cellBackgroundColor
    }
 }
