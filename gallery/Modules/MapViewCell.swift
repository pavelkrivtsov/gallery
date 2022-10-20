//
//  MapViewCell.swift
//  gallery
//
//  Created by Павел Кривцов on 19.10.2022.
//

import UIKit
import SnapKit
import MapKit

protocol MapViewCellProtocol {
    func cellConfiguration(model: CellTypeProtocol)
}

class MapViewCell: UITableViewCell {
    lazy var mapView = MKMapView()
    lazy var mapImageView = UIImageView(image: .init(named: "location"))
    lazy var locationLabel = UILabel()
    lazy var separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(mapView)
        contentView.addSubview(mapImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(separator)
        
        mapView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.height.equalTo(200)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        mapImageView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(8)
            $0.leading.equalTo(mapView.snp.leading)
            $0.width.height.equalTo(16)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(8)
            $0.leading.equalTo(mapImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(mapView.snp.trailing)
            $0.centerY.equalTo(mapImageView.snp.centerY)
        }
        separator.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(mapView.snp.leading)
            $0.height.equalTo(5)
            $0.bottom.equalToSuperview().offset(5)
        }
        separator.backgroundColor = .systemGray4
        mapImageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension MapViewCell: MapViewCellProtocol {
    public func cellConfiguration(model: CellTypeProtocol) {
        guard let locationLabel = model.label else { return }
        self.locationLabel.text = locationLabel.title
        self.locationLabel.font = locationLabel.titleFont
        self.locationLabel.textAlignment = locationLabel.textAlignment
        self.backgroundColor = .systemBlue
    }
 }
