//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 07.08.2025.
//

import Foundation

private struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

private struct LikeResult: Codable {
    let photo: PhotoResult
}

private struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

final class ImagesListService {
    // MARK: - Definition
    private let perPage = 10
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
        
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    private init() { }
    
    // MARK: - Lifecycle
    func fetchPhotosNextPage() {
        if task != nil { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
                
        guard let request = makeRequest(nextPage) else {
            log(URLError(.badURL))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<Array<PhotoResult>, Error>) in
            guard let self else { return }
                        
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    result.forEach { item in
                        let photo = Photo(
                            id: item.id,
                            size: CGSize(width: item.width, height: item.height),
                            createdAt: DateFormatter().date(from: item.createdAt),
                            welcomeDescription: item.description,
                            thumbImageURL: item.urls.thumb,
                            largeImageURL: item.urls.full,
                            isLiked: item.likedByUser
                        )
                        self.photos.append(photo)
                    }
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self
                        )
                    self.lastLoadedPage = nextPage
                case .failure(let error):
                    log(error.localizedDescription)
                }
                self.task = nil
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let request = makeRequest(photoId: photoId, isLike: isLike) else {
            log(URLError(.badURL))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self else { return }
                        
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photoId,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked)
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }
                case .failure(let error):
                    log(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func dispose() {
        photos.removeAll()
        lastLoadedPage = nil
        task = nil
    }
    
    // MARK: - Private func
    private func makeRequest(_ page: Int) -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token else {
            return nil
        }
        
        guard var urlComponents = URLComponents(string: Constants.photosRequest) else {
            log(URLError(.badURL))
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    private func makeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token else {
            return nil
        }
        
        guard
            let urlComponents = URLComponents(string: Constants.photosRequest + "/\(photoId)/like"),
            let url = urlComponents.url else {
            log(URLError(.badURL))
            return nil
        }
                                
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "DELETE" : "POST"
        return request
    }
}
