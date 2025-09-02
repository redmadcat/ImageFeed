//
//  ImagesListViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 31.08.2025.
//

import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var didLoadCalled: Bool = false
    var disposeCalled: Bool = false
    
    func didLoad() {
        didLoadCalled = true
    }
        
    func willDisplayAt(indexPath: IndexPath) {
        
    }
    
    func photosCount() -> Int {
        0
    }
        
    func photoInfoAt(indexPath: IndexPath) -> (
        largeImage: String,
        thumbImage: String,
        createdAt: Date?,
        isLiked: Bool,
        size: CGSize)? {
        return nil
    }
    
    func changeLikeAt(indexPath: IndexPath) -> Bool? {
        nil
    }
    
    func dispose() {
        disposeCalled = true
    }
}
