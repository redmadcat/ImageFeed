//
//  UIImageView+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 28.08.2025.
//

import UIKit
import Foundation
import Kingfisher

extension UIImageView {
    func setImageWith(imageUrl: URL, placeholderImage: UIImage?, cornerRadius: CGFloat, indicatorType: IndicatorType = .activity) {
        let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
        self.kf.indicatorType = indicatorType
        self.kf.setImage(
            with: imageUrl,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
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
    }
}
