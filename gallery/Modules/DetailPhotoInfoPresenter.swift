//
//  DetailPhotoInfoPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import Foundation

protocol DetailPhotoInfoPresenterProtocol: AnyObject {
    func getDetailInfo()
}

class DetailPhotoInfoPresenter {
    weak var view: DetailPhotoInfoViewControllerProtocol?
    private var tableManager: TableManagerProtocol
    private var photo: Photo
    
    init(photo: Photo, tableManager: TableManager) {
        self.photo = photo
        self.tableManager = tableManager
    }
}

extension DetailPhotoInfoPresenter: DetailPhotoInfoPresenterProtocol {
    func getDetailInfo() {
        
        let spacerCell: CellType =  .spacerCell(
            general: CellGeneralProperties(cellHeight: 44,
                                           cellBackgroundColor: .clear))
        let logOutCell: CellType = .labelCell(
            general: CellGeneralProperties { },
            label: CellLabelProperties(title: "test",
                                       titleColor: .systemRed),
            separator: CellSeparatorProperties())
        
        let cellModels: [CellType] = [
            spacerCell,
            logOutCell,
            spacerCell,
            logOutCell,
        ]
        
        DispatchQueue.main.async {
            self.tableManager.fillViewModels(viewModels: cellModels)
        }
    }
}
