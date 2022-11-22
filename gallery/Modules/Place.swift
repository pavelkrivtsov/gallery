//
//  Place.swift
//  gallery
//
//  Created by Павел Кривцов on 25.10.2022.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
