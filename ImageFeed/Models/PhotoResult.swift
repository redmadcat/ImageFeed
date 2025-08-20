//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 20.08.2025.
//

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}
