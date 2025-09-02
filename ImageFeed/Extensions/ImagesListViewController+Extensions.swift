//
//  ImagesListViewControllerDataSource+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 13.06.2025.
//

import UIKit

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { return 0 }
        return presenter.photosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
                
        guard let imageListCell = cell as? ImagesListCell else {
            fatalError("ImagesListCell conversion failed!")
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if CommandLine.arguments.contains("SkipWillDisplay") { return }
        presenter?.willDisplayAt(indexPath: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: getSingleImageSegueIdentifier(), sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photoInfo = presenter?.photoInfoAt(indexPath: indexPath) else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photoInfo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photoInfo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
