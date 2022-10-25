//
//  CellsModels.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

protocol CellTypeProtocol {
    var cellsId: String { get }
    var label: CellLabelPropertiesProtocol? { get }
    var map: CellMapViewPropirtiesProtocol? { get }
    var labelStack: CellLabelStackPropirtiesProtocol? {get}
}

enum CellType {
    case labelCell(label: CellLabelPropertiesProtocol)
    case mapViewCell(label: CellLabelPropertiesProtocol,
                     map: CellMapViewPropirtiesProtocol)
    case stackLabelCell(label: CellLabelStackPropirtiesProtocol)
}


extension CellType: CellTypeProtocol {
    var cellsId: String {
        switch self {
        case .labelCell(label:_):
            return "LabelCell"
        case .mapViewCell(label: _):
            return "MapViewCell"
        case .stackLabelCell(label: _):
            return "StackLabelCell"
        }
    }
    
    var label: CellLabelPropertiesProtocol? {
        switch self {
        case .labelCell(let label):
            return label
        case .mapViewCell(label: let label, map: _):
            return label
        case .stackLabelCell(label: _):
            return nil
        }
    }
    
    var map: CellMapViewPropirtiesProtocol? {
        switch self {
        case .labelCell(label: _):
            return nil
        case .mapViewCell(label: _, map: let map):
            return map
        case .stackLabelCell(label: _):
            return nil
        }
    }
    
    var labelStack: CellLabelStackPropirtiesProtocol? {
        switch self {
        case .labelCell(label: _):
            return nil
        case .mapViewCell(label: _):
            return nil
        case .stackLabelCell(label: let label):
            return label
        }
    }
}

protocol CellLabelPropertiesProtocol {
    var title: String { get }
    var titleFont: UIFont { get }
    var numberOfLines: Int { get }
    var textAlignment: NSTextAlignment { get }
}

struct CellLabelProperties: CellLabelPropertiesProtocol {
    public var title: String = ""
    var titleFont: UIFont = .systemFont(ofSize: 13)
    var numberOfLines: Int = 0
    var textAlignment: NSTextAlignment = .left
}

protocol CellLabelStackPropirtiesProtocol {
    var firstLabelStackTitle: String { get }
    var firstLabelStackText: String { get }
    var secondLabelStackTitle: String { get }    
    var secondLabelStackText: String { get }
}

struct CellLabelStackPropirties: CellLabelStackPropirtiesProtocol {
    var firstLabelStackTitle: String = "-"
    var firstLabelStackText: String = "-"
    var secondLabelStackTitle: String = "-"
    var secondLabelStackText: String = "-"
}

protocol CellMapViewPropirtiesProtocol {
    var latitude: Double { get }
    var longitude: Double { get }
}

struct CellMapViewPropirties: CellMapViewPropirtiesProtocol {
    var latitude: Double
    var longitude: Double
}
