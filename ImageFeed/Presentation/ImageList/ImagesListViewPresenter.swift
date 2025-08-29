//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 29.08.2025.
//

import Foundation

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    // MARK: - Definition
    var view: ImagesListViewControllerProtocol?
    
    init() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                self.view?.updateTableViewAnimated()
            }
    }
}
