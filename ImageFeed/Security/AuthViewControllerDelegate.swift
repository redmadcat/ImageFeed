//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 07.07.2025.
//

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
