//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 07.07.2025.
//

import Foundation

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            storage.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
