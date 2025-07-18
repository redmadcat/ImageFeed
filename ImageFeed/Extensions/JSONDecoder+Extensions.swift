//
//  JSONDecoder+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 18.07.2025.
//

import Foundation

extension JSONDecoder {
    convenience init(strategy: JSONDecoder.KeyDecodingStrategy) {
        self.init()
        keyDecodingStrategy = strategy
    }
}
