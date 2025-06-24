//
//  UILabel+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 24.06.2025.
//

import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor, font: UIFont = .systemFont(ofSize: 13)) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}
