//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 17.07.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func hide() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
