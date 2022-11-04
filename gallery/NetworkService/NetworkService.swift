//
//  NetworkService.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2021.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func getListFromServer(for page: Int, onCompletion: @escaping ([Photo]?) -> Void)
    func getFoundListFromServer(from searchText: String, for page: Int, onCompletion: @escaping (SearchPhotos?) -> Void)
    func getCurrentPhoto(by id: String, onCompletion: @escaping(Photo?) -> Void)
    func downloadPhoto(photo: Photo, onCompletion: @escaping(Data) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func getListFromServer(for page: Int, onCompletion: @escaping ([Photo]?) -> Void) {
        guard let clientId = getEnvironmentVar("API_KEY") else { return }
        let urlString = "https://api.unsplash.com/photos/?page=\(page)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data {
                if let decodeObjects = self?.parseJSON(type: [Photo].self, data: data) {
                    DispatchQueue.main.async {
                        onCompletion(decodeObjects)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func getFoundListFromServer(from searchText: String, for page: Int, onCompletion: @escaping(SearchPhotos?) -> Void) {
        guard let clientId = getEnvironmentVar("API_KEY") else { return }
        let urlString = "https://api.unsplash.com/search/photos?page=\(page)&query=\(searchText)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            if let decodeObjects = self.parseJSON(type: SearchPhotos.self, data: data) {
                DispatchQueue.main.async {
                    onCompletion(decodeObjects)
                }
            }
        }
        task.resume()
    }
    
    func getCurrentPhoto(by id: String, onCompletion: @escaping(Photo?) -> Void) {
        guard let clientId = getEnvironmentVar("API_KEY") else { return }
        let urlString = "https://api.unsplash.com/photos/\(id)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data {
                if let decodeObjects = self?.parseJSON(type: Photo.self, data: data) {
                    DispatchQueue.main.async {
                        onCompletion(decodeObjects)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON<Results: Decodable>(type: Results.Type, data: Data?) -> Results? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
    
    func downloadPhoto(photo: Photo, onCompletion: @escaping(Data) -> Void) {
        guard let clientId = getEnvironmentVar("API_KEY"),
              let url = URL(string: photo.urls.raw) else { return }
        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
    
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            onCompletion(data)
        }
        task.resume()
    }
    
    private func getEnvironmentVar(_ name: String) -> String? {
        guard let rawValue = getenv(name) else { return nil }
        return String(utf8String: rawValue)
    }
}
