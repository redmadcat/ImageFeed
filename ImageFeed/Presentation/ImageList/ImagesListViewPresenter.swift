//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 29.08.2025.
//

import UIKit
import Foundation

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    // MARK: - Definition
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    let imagesListService = ImagesListService.shared
            
    func didLoad() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                self.prepareForUpdate()
            }
        
        imagesListService.fetchPhotosNextPage()
    }
            
    // MARK: - ImagesListViewPresenterProtocol
    func photosCount() -> Int {
        photos.count
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func imageSizeAt(indexPath: IndexPath) -> CGSize? {
        guard let image = self.photos[safe: indexPath.row] else { return nil }
        return image.size
    }
    
    func largeImageURLAt(indexPath: IndexPath) -> String {
        guard let image = self.photos[safe: indexPath.row] else { return "" }
        return image.largeImageURL
    }
    
    func imageDetailsAt(indexPath: IndexPath) -> (thumbImageURL: String, createdAt: Date?, isLiked: Bool)? {
        guard let image = self.photos[safe: indexPath.row] else { return nil }
        return (image.thumbImageURL, image.createdAt, image.isLiked)
    }
    
    func changeLikeAt(indexPath: IndexPath) -> Bool? {
        guard let photo = self.photos[safe: indexPath.row] else { return nil }
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                UIBlockingProgressHUD.hide()
            case .failure(let error):
                UIBlockingProgressHUD.hide()
                self.showError(error)
            }
        }
        return !photo.isLiked
    }
        
    func dispose() {
        self.photos.removeAll()
        self.imagesListService.dispose()
    }
        
    // MARK: - Private func
    private func prepareForUpdate() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.updateTableViewAnimatedAt(indexPaths: indexPaths)
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: error.localizedDescription,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        guard let view = view as? UIViewController else { return }
        view.present(alert, animated: true, completion: nil)
    }
}
