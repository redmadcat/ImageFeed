//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 13.08.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    // MARK: - Definition
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    // MARK: - Lifecycle
    func logout() {
        cleanCookies()
        dispose()
    }
    
    // MARK: - Private func
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func dispose() {
        OAuth2TokenStorage.shared.token = nil
        ProfileImageService.shared.dispose()
        ProfileService.shared.dispose()
        ImagesListService.shared.dispose()
    }
}
