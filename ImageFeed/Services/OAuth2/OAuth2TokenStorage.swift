//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 07.07.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage: ProfileLogoutProtocol, DisposableProtocol {
    static let shared = OAuth2TokenStorage()
    
    private init() {
        subscribeLogout(self)
    }
    
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Keys.bearerToken.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.bearerToken.rawValue)
            }
        }
    }
    
    // MARK: - DisposableProtocol
    func dispose() {
        token = nil
    }
}
