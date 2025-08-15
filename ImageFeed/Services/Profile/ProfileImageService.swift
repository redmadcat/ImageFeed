//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 21.07.2025.
//

import Foundation

private struct UserResult: Codable {
    let profileImage: ProfileImage
}

final class ProfileImageService: ProfileLogoutProtocol, DisposableProtocol {
    // MARK: - Definition
    private let urlSession = URLSession.shared
    private let oauth2Storage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
        
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    private init() {
        subscribeLogout(self)
    }
    
    // MARK: - Lifecycle
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let token = oauth2Storage.token else {
            completion(.failure(NSError(domain: "ProfileImageService", code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "Authorization token missing"])))
            return
        }
        
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
                        
            switch result {
            case .success(let result):
                self.avatarURL = result.profileImage.small
                completion(.success(result.profileImage.small))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL ?? ""]
                    )
            case .failure(let error):
                log(error.localizedDescription)
                completion(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
        
    // MARK: - DisposableProtocol
    func dispose() {
        avatarURL = nil
        task = nil
    }
    
    // MARK: - Private func
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.profileImageRequest)\(username)") else {
            log(URLError(.badURL))
            return nil
        }
                
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}
