//
//  ViewController.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 11.06.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Definition
    let photosName = Array(0..<20).map{ "\($0)" }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 10, left:0, bottom: 12, right: 0)
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        let likeImage = UIImage(named: indexPath.row % 2 == 0 ? "FavoritesActive" : "FavoritesNoActive")
        cell.cellImage.image = image
        cell.dateLabel.text = Date().longDateString
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ViewControllerPreview: PreviewProvider {
    static var devices = ["iPnone SE", "iPhone 11 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ImageList").toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

