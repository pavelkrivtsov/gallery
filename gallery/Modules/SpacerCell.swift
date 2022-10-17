//
//  SpacerCell.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

public protocol SpacerCellProtocol {
    func cellConfiguration(model: CellTypeProtocol)
}

public class SpacerCell: UITableViewCell, SpacerCellProtocol {
    public func cellConfiguration(model: CellTypeProtocol) {
        self.backgroundColor = model.general.cellBackgroundColor
    }
}
