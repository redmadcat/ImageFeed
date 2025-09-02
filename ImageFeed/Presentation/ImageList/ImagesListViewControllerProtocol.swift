//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 29.08.2025.
//

import Foundation

public protocol ImagesListViewControllerProtocol: AnyObject, DisposableProtocol {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func updateTableViewAnimatedAt(indexPaths: [IndexPath])
}
