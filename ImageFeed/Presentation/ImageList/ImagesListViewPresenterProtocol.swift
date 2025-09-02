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
    func photosCount() -> Int
    func willDisplayAt(indexPath: IndexPath)
    func changeLikeAt(indexPath: IndexPath) -> Bool?
    func photoInfoAt(indexPath: IndexPath) -> (
        largeImage: String,
        thumbImage: String,
        createdAt: Date?,
        isLiked: Bool,
        size: CGSize)?
}
