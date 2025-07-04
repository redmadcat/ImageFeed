//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 04.07.2025.
//

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
