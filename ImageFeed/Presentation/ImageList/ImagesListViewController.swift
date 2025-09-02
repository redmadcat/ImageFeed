//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 11.06.2025.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListCellDelegate, ProfileLogoutProtocol, ImagesListViewControllerProtocol {
    // MARK: - @IBOutlet
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Definition
    var presenter: ImagesListViewPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 10, left:0, bottom: 12, right: 0)
        subscribeLogout(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == getSingleImageSegueIdentifier() {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath,
                let largeImageURL = presenter?.largeImageURLAt(indexPath: indexPath)
            else { fatalError("Invalid segue destination or photo is not available!") }
                        
            viewController.fullImageUrl = largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.imageDetailsAt(indexPath: indexPath) else { return }
        
        let placeholderImage = UIImage(named: "Stub")
        cell.delegate = self
        cell.cellImage.backgroundColor = .ypWhiteAlpha50
        cell.cellImage.contentMode = .center
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: URL(string: photo.thumbImageURL),
            placeholder: placeholderImage
        ) { result in
            switch result {
            case .success:
                cell.cellImage.contentMode = .scaleAspectFill
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                let likeImage = UIImage(named: photo.isLiked ? "FavoritesActive" : "FavoritesNoActive")
                if let date = photo.createdAt {
                    cell.dateLabel.text = date.longDateString
                }
                cell.likeButton.setImage(likeImage, for: .normal)
            case .failure(let error):
                cell.cellImage.image = placeholderImage
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
            let result = presenter?.changeLikeAt(indexPath: indexPath)
        else { return }
                             
        cell.setIsLiked(isLiked: result)
    }
        
    // MARK: - ImagesListViewControllerProtocol
    func updateTableViewAnimated(indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    // MARK: - DisposableProtocol
    func dispose() {
        self.presenter?.dispose()
        self.tableView.reloadData()
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

