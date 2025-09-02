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
        
    func fetchPhotosNextPage() {
    }
    
    func photosCount() -> Int {
        0
    }
    
    func imageSizeAt(indexPath: IndexPath) -> CGSize? {
        return nil
    }
    
    func largeImageURLAt(indexPath: IndexPath) -> String {
        return ""
    }
    
    func imageDetailsAt(indexPath: IndexPath) -> (thumbImageURL: String, createdAt: Date?, isLiked: Bool)? {
        return nil
    }
    
    func changeLikeAt(indexPath: IndexPath) -> Bool? {
        nil
    }
    
    func dispose() {
        disposeCalled = true
    }
}
