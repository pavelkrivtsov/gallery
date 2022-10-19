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
            general: CellGeneralProperties())
        
        let logOutCell: CellType = .labelCell(
            general: CellGeneralProperties(cellBackgroundColor: .systemBlue),
            label: CellLabelProperties(title: "TEST",
                                       titleFont: .boldSystemFont(ofSize: 30),
                                       textAlignment: .left),
            separator: CellSeparatorProperties(backgroundColor: .cyan))
        
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
