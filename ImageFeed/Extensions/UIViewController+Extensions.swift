//
//  UIViewController+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 14.06.2025.
//

import UIKit

#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
    static var devices = ["iPnone SE", "iPhone 11 Pro Max"]
    
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(viewController: self)
    }
}
#endif
