//
//  NetworkService.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2021.
//

import Foundation

class NetworkService {
    
    private let clientId = "Client-ID H8VOOo5_EjEw5KJsHXBoxTzOL525-OPZ-58HmdHX4sQ"
    
    func fetchImagesList(onCompletion: @escaping ([UnsplashPhoto]?) -> Void) {
        let urlString = "https://api.unsplash.com/photos/?"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data {
                if let decodeObjects = self?.parseJSON(type: [UnsplashPhoto].self, data: data) {
                    DispatchQueue.main.async {
                        onCompletion(decodeObjects)
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchSearchigImages(searchItem: String, onCompletion: @escaping (SearchResults?) -> Void ) {
        let urlString = "https://api.unsplash.com/search/photos?query=\(searchItem)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            if let decodeObjects = self.parseJSON(type: SearchResults.self, data: data) {
                DispatchQueue.main.async {
                    onCompletion(decodeObjects)
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
    
}
