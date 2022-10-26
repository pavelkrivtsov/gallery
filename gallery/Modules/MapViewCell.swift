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
    lazy var mapImageView = UIImageView(image: appearance.locationPinImage)
    lazy var locationLabel = UILabel()
    lazy var separator = UIView(frame: .zero)
    lazy var appearance = Appearance()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(mapView)
        contentView.addSubview(mapImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(separator)
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(appearance.sideMargin)
            $0.height.equalTo(appearance.mapHeight)
        }
        mapImageView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(appearance.sideMargin / 2)
            $0.leading.equalTo(mapView.snp.leading)
            $0.width.height.equalTo(appearance.sideMargin)
            $0.bottom.equalToSuperview().inset(appearance.sideMargin)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(appearance.sideMargin / 2)
            $0.leading.equalTo(mapImageView.snp.trailing).offset(appearance.sideMargin / 2)
            $0.trailing.equalTo(mapView.snp.trailing)
            $0.centerY.equalTo(mapImageView.snp.centerY)
        }
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(appearance.sideMargin)
            $0.height.equalTo(1)
        }
        separator.backgroundColor = .systemGray
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
        self.separator.isHidden = locationLabel.separatorIsHidden
        self.locationLabel.text = locationLabel.title
        self.locationLabel.font = locationLabel.titleFont
        
        let location = CLLocation(latitude: model.map!.latitude,
                                  longitude: model.map!.longitude)
        let region = MKCoordinateRegion(center: location.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: appearance.coordinateSpan,
                                                               longitudeDelta: appearance.coordinateSpan))
        self.mapView.setRegion(region, animated: true)
        self.mapView.regionThatFits(region)
        let annotation = Place(coordinate: .init(latitude: location.coordinate.latitude,
                                                 longitude: location.coordinate.longitude))
        self.mapView.addAnnotation(annotation)
    }
}

