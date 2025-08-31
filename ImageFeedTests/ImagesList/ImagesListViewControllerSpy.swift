//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 31.08.2025.
//

import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    var didUpdateTableViewAnimatedCalled: Bool = false
    var disposeCalled: Bool = false
    
    func updateTableViewAnimated() {
        didUpdateTableViewAnimatedCalled = true
    }
    
    func dispose() {
        disposeCalled = true
    }
}
