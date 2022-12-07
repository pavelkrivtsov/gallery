//
//  NetworkManager.swift
//  gallery
//
//  Created by Павел Кривцов on 19.09.2021.
//

import Foundation

enum NetworkResult<Error> {
    case success
    case failure(Error)
}

enum NetworkResponse: String, Error {
    case authenticationError = "Authentication error"
    case badRequest = "Bad request"
    case outdated = "Outdated"
    case failed = "Failed"
    case noData = "No data"
    case unableToDecode = "Unable to decode"
}

protocol NetworkManagerOutput: AnyObject {
    func cancelDownloadTask()
    func getPhotos(from page: Int, onCompletion: @escaping (Result<[Photo], NetworkResponse>) -> Void)
    func getFoundPhotos(from page: Int,from searchText: String, onCompletion: @escaping (Result<[Photo], NetworkResponse>) -> Void)
    func getSelectedPhoto(by id: String, onCompletion: @escaping (Result<Photo, NetworkResponse>) -> Void)
    func downloadPhoto(photo: Photo)
}

class NetworkManager: NSObject {
    
    weak var presenter: NetworkServiceInput?
    private var task : URLSessionTask?
    
    private func taskResume<T: Decodable>(from urlString: String,
                                          type: T.Type,
                                          onCompletion: @escaping(Result<T, NetworkResponse>) -> Void) {
        
        
        guard let url = URL(string: urlString) else {
            onCompletion(.failure(NetworkResponse.badRequest))
            return
        }
        
        guard let clientId = getEnvironmentVar("API_KEY") else { return }
        
        var request = URLRequest(url: url)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if error != nil {
                onCompletion(.failure(NetworkResponse.failed))
            }
            
            if let response = response as? HTTPURLResponse {
                guard let result = self?.handleNetworkResponse(response) else { return }
                switch result {
                case .success:
                    guard let responseData = data else {
                        onCompletion(.failure(NetworkResponse.noData))
                        return
                    }
                
                    do {
                        let apiResponse = try JSONDecoder().decode(type, from: responseData)
                        onCompletion(.success(apiResponse))
                    } catch {
                        onCompletion(.failure(NetworkResponse.unableToDecode))
                    }
                    
                case .failure(let failureError):
                    onCompletion(.failure(failureError))
                }
            }
        }
        task?.resume()
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<NetworkResponse> {
        switch response.statusCode {
        case 200...299 : return .success
        case 401...500 : return .failure(NetworkResponse.authenticationError)
        case 501...599 : return .failure(NetworkResponse.badRequest)
        case 600 : return .failure(NetworkResponse.outdated)
        default: return .failure(NetworkResponse.failed)
        }
    }
    
    private func getEnvironmentVar(_ name: String) -> String? {
        guard let rawValue = getenv(name) else { return nil }
        return String(utf8String: rawValue)
    }
}

extension NetworkManager: NetworkManagerOutput {

    func getPhotos(from page: Int, onCompletion: @escaping (Result<[Photo], NetworkResponse>) -> Void) {
        let urlString = "https://api.unsplash.com/photos/?page=\(page)"
        taskResume(from: urlString, type: [Photo].self) { result in
            switch result {
            case .success(let photos):
                onCompletion(.success(photos))
            case .failure(let failureError):
                onCompletion(.failure(failureError))
            }
        }
    }

    func getFoundPhotos(from page: Int,
                        from searchText: String,
                        onCompletion: @escaping (Result<[Photo], NetworkResponse>) -> Void) {

        let urlString = "https://api.unsplash.com/search/photos?page=\(page)&query=\(searchText)"
//        let urlString = "https://api.unsplash.com/search/photos?page=1&query=v%20f"
        
        taskResume(from: urlString, type: SearchResults.self) { result in
            switch result {
            case .success(let searchResults):
                onCompletion(.success(searchResults.results))
            case .failure(let failureError):
                onCompletion(.failure(failureError))
            }
        }
        
    }
    
    func getSelectedPhoto(by id: String, onCompletion: @escaping (Result<Photo, NetworkResponse>) -> Void){
        let urlString = "https://api.unsplash.com/photos/\(id)"
        taskResume(from: urlString, type: Photo.self) { result in
            switch result {
            case .success(let photo):
                onCompletion(.success(photo))
            case .failure(let failureError):
                onCompletion(.failure(failureError))
            }
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
        task = session.downloadTask(with: request)
        task?.resume()
    }
    
    func cancelDownloadTask() {
        task?.cancel()
    }
}

extension NetworkManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            presenter?.failedDownloadPhoto()
            return
        }
        presenter?.savePhoto(from: data)
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        presenter?.trackDownloadProgress(progress: progress)
    }
}
