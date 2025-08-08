//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 07.08.2025.
//

import Foundation

private struct PhotoResults: Codable {
    let items: [PhotoResult]
}

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
    let description: String
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
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
        
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Lifecycle
    private func fetchPhotosNextPage() {
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeImagesRequest() else {
            log(URLError(.badURL))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoResults, Error>) in
            guard let self else { return }
                        
            switch result {
            case .success(let result):
                result.items.forEach { item in
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
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private func
    private func makeImagesRequest() -> URLRequest? {
        guard let url = URL(string: Constants.imagesRequest) else {
            log(URLError(.badURL))
            return nil
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
