//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 18.07.2025.
//

import Foundation

private struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}

final class ProfileService {
    // MARK: - Definition
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    static let shared = ProfileService()
    
    private init() { }
    
    // MARK: - Lifecycle
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeProfileRequest(token) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
                        
            switch result {
            case .success(let result):
                let profile = Profile(
                    username: result.username,
                    name: result.firstName + " " + result.lastName,
                    loginName: "@\(result.username)",
                    bio: result.bio
                )
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                log(error.localizedDescription)
                completion(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private func
    private func makeProfileRequest(_ token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            log(URLError(.badURL))
            return nil
        }
                
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}
