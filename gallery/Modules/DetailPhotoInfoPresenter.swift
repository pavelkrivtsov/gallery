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
    
        let descriptionCell: [CellType] = {
            guard let description = self.photo.photoDescription else { return [] }
            return [
                .labelCell(
                    label: CellLabelProperties(title: description,
                                               titleFont: .systemFont(ofSize: 16),
                                               textAlignment: .left)
                )
            ]
        }()
        
        let mapView: [CellType] =  {
            guard let location = self.photo.location else { return [] }
            return [
                .mapViewCell(label: CellLabelProperties(title: "\(location.city ?? "-"), \(location.country ?? "-")",
                                                        titleFont: .systemFont(ofSize: 16),
                                                        numberOfLines: 1))
            ]
        }()
        
        let cameraLabel: [CellType] = {
            return [.labelCell(label: CellLabelProperties(title: "Camera",
                                                         titleFont: .boldSystemFont(ofSize: 17)))]
        }()
            
        let cellModels: [CellType] = descriptionCell + mapView + cameraLabel
            
        
        DispatchQueue.main.async {
            self.tableManager.fillViewModels(viewModels: cellModels)
        }
    }
}
