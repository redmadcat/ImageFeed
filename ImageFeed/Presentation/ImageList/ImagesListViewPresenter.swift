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
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
            
    func didLoad() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                self.prepareForUpdate()
            }
        
        fetchNextPhotos()
    }
            
    // MARK: - ImagesListViewPresenterProtocol
    func photosCount() -> Int {
        photos.count
    }
    
    func willDisplayAt(indexPath: IndexPath) {
        if indexPath.row + 1 == photosCount() {
            fetchNextPhotos()
        }
    }
    
    func changeLikeAt(indexPath: IndexPath) -> Bool? {
        guard let photo = getPhotoAt(indexPath: indexPath) else { return nil }
        
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
    
    func photoInfoAt(indexPath: IndexPath) -> (
        largeImage: String,
        thumbImage: String,
        createdAt: Date?,
        isLiked: Bool,
        size: CGSize)? {
        guard let photo = getPhotoAt(indexPath: indexPath) else { return nil }
        return (photo.largeImageURL, photo.thumbImageURL, photo.createdAt, photo.isLiked, photo.size)
    }
        
    func dispose() {
        self.photos.removeAll()
        self.imagesListService.dispose()
    }
        
    // MARK: - Private func
    private func fetchNextPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    private func getPhotoAt(indexPath: IndexPath) -> Photo? {
        guard let photo = self.photos[safe: indexPath.row] else { return nil }
        return photo
    }
    
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
