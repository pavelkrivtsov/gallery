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
    private var tableManager: DetailTableManagerProtocol
    private var photo: Photo
    
    init(photo: Photo, tableManager: DetailTableManager) {
        self.photo = photo
        self.tableManager = tableManager
    }
}

extension DetailPhotoInfoPresenter: DetailPhotoInfoPresenterProtocol {
    
    func getDetailInfo() {
        
        let authorTitleCell: [CellType] = {
            return [
                .labelCell(label: CellLabelProperties(title: "Info",
                                                      titleFont: .systemFont(ofSize: 17, weight: .bold),
                                                      titleAligment: .center,
                                                      bottomSideMargin: 0,
                                                      numberOfLines: 1)
                )
            ]
        }()
        
        let descriptionCell: [CellType] = {
            guard let description = self.photo.photoDescription else { return [] }
            return [
                .labelCell(
                    label: CellLabelProperties(title: description,
                                               titleFont: .systemFont(ofSize: 17, weight: .light),
                                               separatorIsHidden: false)
                )
            ]
        }()
        
        let mapViewCell: [CellType] =  {
            guard let latitude = self.photo.location?.position.latitude,
                  let longitude = self.photo.location?.position.longitude else { return [] }
            return [
                .mapViewCell(
                    label: CellLabelProperties(title: "\(self.photo.location?.name ?? "-")",
                                               separatorIsHidden: false),
                    map: CellMapViewPropirties(latitude: latitude, longitude: longitude)
                )
            ]
        }()
        
        let cameraLabelCell: [CellType] = {
            return [
                .labelCell(
                    label: CellLabelProperties(title: "Camera",
                                               titleFont: .boldSystemFont(ofSize: 17),
                                               bottomSideMargin: 4)
                )
            ]
        }()
        
        let stackLabelCell: [CellType] = {
            
            let dateOfPublication = self.photo.createdAt
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let date = dateFormatter.date(from: dateOfPublication)
            let dateString = dateFormatter.string(from: date ?? Date())
            
            return [
                .stackLabelCell(
                    label: CellLabelStackPropirties(firstLabelStackTitle: "Make",
                                                    firstLabelStackText: self.photo.exif?.make ?? "-",
                                                    secondLabelStackTitle: "Focal Length (mm)",
                                                    secondLabelStackText: self.photo.exif?.focalLength ?? "-")
                ),
                .stackLabelCell(
                    label: CellLabelStackPropirties(firstLabelStackTitle: "Model",
                                                    firstLabelStackText: self.photo.exif?.model ?? "-",
                                                    secondLabelStackTitle: "ISO",
                                                    secondLabelStackText: String(self.photo.exif?.iso ?? 0))
                ),
                .stackLabelCell(
                    label: CellLabelStackPropirties(firstLabelStackTitle: "Shutter Speed (s)",
                                                    firstLabelStackText: self.photo.exif?.exposureTime ?? "-",
                                                    secondLabelStackTitle: "Dimensions",
                                                    secondLabelStackText: "\(self.photo.width)﹡\(self.photo.height)" )
                ),
                .stackLabelCell(
                    label: CellLabelStackPropirties(firstLabelStackTitle: "Aperture (f)",
                                                    firstLabelStackText: self.photo.exif?.aperture ?? "-",
                                                    secondLabelStackTitle: "Published",
                                                    secondLabelStackText: dateString)
                )
            ]
        }()
        
        let cellModels: [CellType] = authorTitleCell + descriptionCell + mapViewCell + cameraLabelCell + stackLabelCell
        
        DispatchQueue.main.async { [weak self] in
            self?.tableManager.fillViewModels(viewModels: cellModels)
        }
    }
}
