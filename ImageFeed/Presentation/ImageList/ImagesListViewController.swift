//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 11.06.2025.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListCellDelegate, ProfileLogoutProtocol, DisposableProtocol {
    // MARK: - @IBOutlet
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Definition
    var photos: [Photo] = []
    let imagesListService = ImagesListService.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 10, left:0, bottom: 12, right: 0)
        imagesListService.fetchPhotosNextPage()
        
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                self.updateTableViewAnimated()
            }
        
        subscribeLogout(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == getSingleImageSegueIdentifier() {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath,
                let photo = self.photos[safe: indexPath.row]
            else { fatalError("Invalid segue destination or photo is not available!") }
                        
            viewController.fullImageUrl = photo.largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = self.photos[safe: indexPath.row] else { return }
        
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        cell.delegate = self
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: URL(string: photo.thumbImageURL),
            placeholder: placeholderImage
        ) { result in
            switch result {
            case .success:
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                let likeImage = UIImage(named: photo.isLiked ? "FavoritesActive" : "FavoritesNoActive")
                cell.likeButton.setImage(likeImage, for: .normal)
                cell.dateLabel.text = photo.createdAt?.longDateString
            case .failure(let error):
                log(error.localizedDescription)
            }
        }
    }
    
    func getSingleImageSegueIdentifier() -> String {
        "ShowSingleImage"
    }
    
    // MARK: - ImagesListCellDelegate
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let photo = self.photos[safe: indexPath.row] else { return }
     
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.hide()
            case .failure(let error):
                UIBlockingProgressHUD.hide()
                self.showError(error)
            }
        }
    }
    
    // MARK: - DisposableProtocol
    func dispose() {
        self.photos.removeAll()
        self.tableView.reloadData()
    }
    
    // MARK: - Private func
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: error.localizedDescription,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ImagesListViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(UIViewController.devices, id: \.self) { deviceName in
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ImageList").toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

