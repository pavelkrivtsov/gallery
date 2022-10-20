//
//  CellsModels.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

public protocol CellTypeProtocol {
    var cellsId: String { get }
    var label: CellLabelPropertiesProtocol? { get }
}

public enum CellType {
    case labelCell(label: CellLabelPropertiesProtocol)
    case mapViewCell(label: CellLabelPropertiesProtocol)
}


extension CellType: CellTypeProtocol {

    public var cellsId: String {
        switch self {
        case .labelCell(label:_):
            return "LabelCell"
        case .mapViewCell(label: _):
            return "MapViewCell"
        }
    }
    
    public var label: CellLabelPropertiesProtocol? {
        switch self {
        case .labelCell(let label):
            return label
        case .mapViewCell(let label):
            return label
        }
    }
}

public protocol CellLabelPropertiesProtocol {
    var title: String { get }
//    var titleColor: UIColor { get }
    var titleFont: UIFont { get }
    var numberOfLines: Int { get }
    var textAlignment: NSTextAlignment { get }
}

public struct CellLabelProperties: CellLabelPropertiesProtocol {
    public var title: String = ""
//    public var titleColor: UIColor = .white
    public var titleFont: UIFont = .systemFont(ofSize: 17)
    public var numberOfLines: Int = 0
    public var textAlignment: NSTextAlignment = .left
}

