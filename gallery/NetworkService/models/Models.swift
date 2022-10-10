//
//  Models.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import Foundation

// MARK: - SearchPhotos
struct SearchPhotos: Codable {
    let total, totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Photo
struct Photo: Codable, Hashable {
    let id: String
    let width, height: Int
    let color, blurHash: String
    let photoDescription: String?
    let altDescription: String?
    let urls: Urls
    let links: PhotosLinks
    let likes: Int
    let likedByUser: Bool
    let user: User
    let exif: Exif?
    let location: Location?
    
    enum CodingKeys: String, CodingKey {
        case id
        case width, height, color
        case blurHash = "blur_hash"
        case photoDescription = "description"
        case altDescription = "alt_description"
        case urls, links, likes
        case likedByUser = "liked_by_user"
        case user, exif, location
    }
}

// MARK: - Urls
struct Urls: Codable, Hashable {
    let raw, full, regular, small, thumb, smallS3: String
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

// MARK: - Links
struct PhotosLinks: Codable, Hashable {
    let linksSelf, html, download, downloadLocation: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - User
struct User: Codable, Hashable {
    let id: String
    let username, name, firstName, lastName: String?
    let bio: String?
    let location: String?
    let links: UserLinks
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case bio, location, links
        case profileImage = "profile_image"
    }
}

// MARK: - Links
struct UserLinks: Codable, Hashable {
    let linksSelf, html, photos, likes: String
    let portfolio, following, followers: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

struct ProfileImage: Codable, Hashable {
    let small, medium, large: String
}

// MARK: - Exif
struct Exif: Codable, Hashable {
    let make, model, name, exposureTime: String
    let aperture, focalLength: String
    let iso: Int
    
    enum CodingKeys: String, CodingKey {
        case make, model, name
        case exposureTime = "exposure_time"
        case aperture
        case focalLength = "focal_length"
        case iso
    }
}

// MARK: - Location
struct Location: Codable, Hashable {
    let name, city, country: String?
    let position: Position
}

// MARK: - Position
struct Position: Codable, Hashable {
    let latitude, longitude: Double
}
