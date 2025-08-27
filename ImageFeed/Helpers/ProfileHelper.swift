//
//  ProfileHelper.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 26.08.2025.
//

import UIKit

final class ProfileHelper: DisposableProtocol {
    
    // MARK: - DisposableProtocol
    func dispose() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid window configuration")
        }
        
        window.rootViewController = SplashViewController()
    }
}
