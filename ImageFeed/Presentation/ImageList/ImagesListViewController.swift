//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 11.06.2025.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == getSingleImageSegueIdentifier() {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                fatalError("Invalid segue destination!")
            }
//            viewController.image = UIImage(named: photoNames[indexPath.row])
//            viewController.image?.kf. =  self.photos[safe: indexPath.row]
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: URL(string: photo.thumbImageURL),
            placeholder: placeholderImage,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                case .failure(let error):
                    log(error.localizedDescription)
                }
            }
        
        let likeImage = UIImage(named: photo.isLiked ? "FavoritesActive" : "FavoritesNoActive")
        cell.dateLabel.text = photo.createdAt?.longDateString
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func getSingleImageSegueIdentifier() -> String {
        "ShowSingleImage"
    }
    
    // MARK: - Private func
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

