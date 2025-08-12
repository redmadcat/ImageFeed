//
//  Array+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 12.08.2025.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
