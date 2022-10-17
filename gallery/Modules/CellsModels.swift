//
//  CellsModels.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import UIKit

public protocol CellTypeProtocol {
    var cellsId: String { get }
    var general: CellGeneralPropertiesProtocol { get }
    var label: CellLabelPropertiesProtocol? { get }
    var descriptionLabel: CellLabelPropertiesProtocol? { get }
    var separator: CellSeparatorPropertiesProtocol? { get }
    var image: CellImagePropertiesProtocol? { get }
}

public enum CellType {
    case spacerCell(general: CellGeneralPropertiesProtocol)
    
    case labelCell(general: CellGeneralPropertiesProtocol,
                   label: CellLabelPropertiesProtocol,
                   separator: CellSeparatorPropertiesProtocol)
}


extension CellType: CellTypeProtocol {

    public var cellsId: String {
        switch self {
        case .spacerCell(general: _):
            return "SpacerCell"
        case .labelCell(general: _, label: _, separator: _):
            return "LabelCell"
        }
    }
    
    public var general: CellGeneralPropertiesProtocol {
        switch self {
        case .spacerCell(general: let general),
                .labelCell(general: let general, label: _, separator: _):
            return general
        }
    }
    
    public var label: CellLabelPropertiesProtocol? {
        switch self {
        case .spacerCell(general: _):
            return nil
        case .labelCell(general: _, let label, separator: _):
            return label
        }
    }
    
    public var descriptionLabel: CellLabelPropertiesProtocol? {
        switch self {
        case .spacerCell(general: _):
            return nil
        case .labelCell(general: _, label: _, separator: _):
            return nil
        }
    }
    
    public var image: CellImagePropertiesProtocol? {
        switch self {
        case .spacerCell(general: _):
            return nil
        case .labelCell(general: _, label: _, separator: _):
            return nil
        }
    }
    
    public var separator: CellSeparatorPropertiesProtocol? {
        switch self {
        case .spacerCell(general: _):
            return nil
        case .labelCell(general: _, label: _, separator: let separator):
            return separator
        }
    }
}

public protocol CellGeneralPropertiesProtocol {
    var id: Int?  { get }
    var cellHeight: CGFloat { get }
    var cellBackgroundColor: UIColor { get }
    var tapAction: (() -> Void)? { get }
}

public struct CellGeneralProperties: CellGeneralPropertiesProtocol {
    public var id: Int? = nil
    public var cellHeight: CGFloat = 44
    public var cellBackgroundColor: UIColor = .systemBlue
    public var tapAction: (() -> Void)?
}

public protocol CellLabelPropertiesProtocol {
    var title: String { get }
    var titleColor: UIColor { get }
    var titleFont: UIFont { get }
    var numberOfLines: Int { get }
    var textAlignment: NSTextAlignment { get }
    var leadingConstraint: CGFloat? { get }
    var trailingConstraint: CGFloat? { get }
}

public struct CellLabelProperties: CellLabelPropertiesProtocol {
    public var title: String = ""
    public var titleColor: UIColor = .white
    public var titleFont: UIFont = .systemFont(ofSize: 17)
    public var numberOfLines: Int = 0
    public var textAlignment: NSTextAlignment = .left
    public var leadingConstraint: CGFloat?
    public var trailingConstraint: CGFloat?
}

public protocol CellSeparatorPropertiesProtocol {
    var isHidden: Bool { get }
    var backgroundColor: UIColor  { get }
    var backgroundColorAlfa: CGFloat { get }
    var leadingConstraint: CGFloat? { get set }
}

public struct CellSeparatorProperties: CellSeparatorPropertiesProtocol {
    public var isHidden: Bool = false
    public var backgroundColor: UIColor = .clear
    public var backgroundColorAlfa: CGFloat = 1
    public var leadingConstraint: CGFloat? = 0
}

public protocol CellImagePropertiesProtocol {
    var image: String { get }
    var imageContentMode: UIView.ContentMode { get }
    var isRadio: Bool? { get }
    var leadingConstraint: CGFloat? { get }
}

public struct CellImageProperties: CellImagePropertiesProtocol {
    public var image: String = ""
    public var imageContentMode: UIView.ContentMode = .scaleAspectFit
    public var isRadio: Bool? = false
    public var leadingConstraint: CGFloat?
}
