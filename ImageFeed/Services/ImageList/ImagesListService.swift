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
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
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
    private var lastLoadedPage: Int = 0
        
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    private init() { }
    
    // MARK: - Lifecycle
    func fetchPhotosNextPage() {
        if task != nil { return }
        lastLoadedPage += 1
        let nextPage = lastLoadedPage
                
        guard let request = makeImagesRequest(nextPage) else {
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
        if task != nil { return }
        
        guard let request = makeLikeRequest(photoId: photoId, isLike: isLike) else {
            log(URLError(.badURL))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] (result: Result<Data, Error>) in
            guard let self else { return }
                        
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
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
//                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                    }
                case .failure(let error):
                    log(error.localizedDescription)
                }
                self.task = nil
            }
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private func
    private func makeImagesRequest(_ page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.imagesRequest) else {
            log(URLError(.badURL))
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let photosUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: photosUrl)
        request.httpMethod = "GET"
        return request
    }
    
    private func makeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.imagesRequest) else {
            log(URLError(.badURL))
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "id", value: "\(photoId)"),
            URLQueryItem(name: "like", value: "\(isLike)")
        ]
        
        guard let photosUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: photosUrl)
        request.httpMethod = isLike ? "POST" : "DELETE"
        return request
    }
}
