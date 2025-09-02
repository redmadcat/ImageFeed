//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 31.08.2025.
//

import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    func updateTableViewAnimatedAt(indexPaths: [IndexPath]) {
        
    }
    
    func dispose() {
        
    }
}
