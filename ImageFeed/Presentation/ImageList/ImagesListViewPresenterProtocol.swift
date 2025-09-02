//
//  ImagesListViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 29.08.2025.
//

import Foundation

public protocol ImagesListViewPresenterProtocol: DisposableProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func didLoad()
    func fetchPhotosNextPage()
    func photosCount() -> Int
    func imageSizeAt(indexPath: IndexPath) -> CGSize?
    func largeImageURLAt(indexPath: IndexPath) -> String
    func imageDetailsAt(indexPath: IndexPath) -> (thumbImageURL: String, createdAt: Date?, isLiked: Bool)?
    func changeLikeAt(indexPath: IndexPath) -> Bool?
}
