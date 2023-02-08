//
//  DetailPhotoInfoPresenter.swift
//  gallery
//
//  Created by Павел Кривцов on 17.10.2022.
//

import Foundation

protocol DetailPhotoInfoViewOutput: AnyObject {
    func getDetailInfo()
}

class DetailPhotoInfoPresenter {
    
    private let tableManager: DetailTableManagerOutput
    private let photo: Photo
    
    init(photo: Photo, tableManager: DetailTableManagerOutput) {
        self.photo = photo
        self.tableManager = tableManager
    }
}

// MARK: - DetailPhotoInfoViewOutput
extension DetailPhotoInfoPresenter: DetailPhotoInfoViewOutput {
    
    func getDetailInfo() {
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
        
        let cellModels: [CellType] = descriptionCell + mapViewCell + cameraLabelCell + stackLabelCell
        self.tableManager.fillViewModels(viewModels: cellModels)
    }
}
