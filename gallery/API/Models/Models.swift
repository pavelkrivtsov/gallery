//
//  Models.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import Foundation

// MARK: - SearchPhotos
struct SearchResults: Decodable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}

// MARK: - Photo
struct Photo: Decodable, Hashable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let photoDescription: String?
    let urls: Urls
    let user: User
    let exif: Exif?
    let location: Location?
    
    enum CodingKeys: String, CodingKey {
        case id, urls, user, exif, location, width, height
        case createdAt = "created_at"
        case photoDescription = "description"
    }
}

// MARK: - Urls
struct Urls: Decodable, Hashable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let smallS3: String
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

// MARK: - User
struct User: Decodable, Hashable {
    let id: String
    let username: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

// MARK: - Exif
struct Exif: Decodable, Hashable {
    let make: String?
    let model: String?
    let name: String?
    let exposureTime: String?
    let aperture: String?
    let focalLength: String?
    let iso: Int?
    
    enum CodingKeys: String, CodingKey {
        case make, model, name, aperture, iso
        case exposureTime = "exposure_time"
        case focalLength = "focal_length"
    }
}

// MARK: - Location
struct Location: Decodable, Hashable {
    let name: String?
    let city: String?
    let country: String?
    let position: Position
}

// MARK: - Position
struct Position: Decodable, Hashable {
    let latitude: Double?
    let longitude: Double?
}
