//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 13.08.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService: DisposableProtocol {
    // MARK: - Definition
    static let didLogoutNotification = Notification.Name(rawValue: "ProfileLogoutServiceDidLogout")
    static let shared = ProfileLogoutService()
    
    private init() { }
        
    // MARK: - DisposableProtocol
    func dispose() {
        cleanCookies()
        NotificationCenter.default
            .post(
                name: ProfileLogoutService.didLogoutNotification,
                object: self
            )
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
}
