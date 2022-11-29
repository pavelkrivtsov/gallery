//
//  NetworkService.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2021.
//

import Foundation

protocol NetworkServiceOutput: AnyObject {
    func getListFromServer(for page: Int, onCompletion: @escaping ([Photo]?) -> Void)
    func getFoundListFromServer(from searchText: String, for page: Int, onCompletion: @escaping([Photo]?) -> Void)
    func getCurrentPhoto(by id: String, onCompletion: @escaping(Photo?) -> Void)
    func downloadPhoto(photo: Photo)
}

class NetworkService: NSObject {
    
    weak var presenter: NetworkServiceInput?
    
    private func taskResume<Results: Decodable>(from urlString: String,
                                                type: Results.Type,
                                                clientId: String,
                                                onCompletion: @escaping(Results) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            if let decodeObjects = self.parseJSON(type: type, data: data) {
                onCompletion(decodeObjects)
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
    
    private func getEnvironmentVar(_ name: String) -> String? {
        guard let rawValue = getenv(name) else { return nil }
        return String(utf8String: rawValue)
    }
}

extension NetworkService: NetworkServiceOutput {
    
    func getListFromServer(for page: Int, onCompletion: @escaping ([Photo]?) -> Void) {
        guard let clientId = getEnvironmentVar("API_KEY") else { return }
        let urlString = "https://api.unsplash.com/photos/?page=\(page)"
        self.taskResume(from: urlString, type: [Photo].self, clientId: clientId) { photos in
            onCompletion(photos)
        }
    }
    
    func getFoundListFromServer(from searchText: String, for page: Int, onCompletion: @escaping([Photo]?) -> Void) {
        guard let clientId = getEnvironmentVar("API_KEY") else { return }
        let urlString = "https://api.unsplash.com/search/photos?page=\(page)&query=\(searchText)"
        self.taskResume(from: urlString, type: SearchResults.self, clientId: clientId) { searchResults in
            let photos = searchResults.results
            onCompletion(photos)
        }
    }

    func getCurrentPhoto(by id: String, onCompletion: @escaping(Photo?) -> Void) {
        guard let clientId = getEnvironmentVar("API_KEY") else { return }
        let urlString = "https://api.unsplash.com/photos/\(id)"
        self.taskResume(from: urlString, type: Photo.self, clientId: clientId) { photo in
            onCompletion(photo)
        }
    }
    
    func downloadPhoto(photo: Photo) {
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)
        
        guard let clientId = getEnvironmentVar("API_KEY"),
              let url = URL(string: photo.urls.raw) else { return }
        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        session.downloadTask(with: request).resume()
    }
}

extension NetworkService: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            print("The data could be loaded")
            return
        }
        self.presenter?.savePhoto(from: data)
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        self.presenter?.trackDownloadProgress(progress: progress)
    }
}
