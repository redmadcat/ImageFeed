//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 13.06.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - @IBOutlet
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Definition
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        dateLabel.text = nil
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = UIImage(named: isLiked ? "FavoritesActive" : "FavoritesNoActive")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    // MARK: - @IBAction
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
