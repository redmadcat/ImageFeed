//
//  DisposableProtocol+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 15.08.2025.
//

import Foundation

extension ProfileLogoutProtocol {
    func subscribeLogout(_ T: DisposableProtocol) {
        NotificationCenter.default.addObserver(
            forName: ProfileLogoutService.didLogoutNotification,
            object: nil,
            queue: .main) { _ in
                T.dispose()
            }
    }
}
