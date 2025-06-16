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
}
