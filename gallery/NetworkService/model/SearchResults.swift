//
//  SearchResults.swift
//  gallery
//
//  Created by Павел Кривцов on 20.09.2022.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashImage]
}

struct UnsplashImage: Decodable {
    let user: User
    let description: String?
    let width: Int
    let height: Int
    let urls: [URLKing.RawValue:String]
    
    enum URLKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct User: Decodable {
    let name: String
}
