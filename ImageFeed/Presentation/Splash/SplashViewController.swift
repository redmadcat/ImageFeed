//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 07.07.2025.
//

import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    // MARK: - Definition
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let tabBarViewControllerIdentifier = "TabBarViewController"
    private let oauth2Storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2Storage.token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else {
                fatalError("Invalid segue destination \(showAuthenticationScreenSegueIdentifier)!")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
        
    // MARK: - Private func
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid window configuration")
        }
        
        let tabBarViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: tabBarViewControllerIdentifier)
        
        window.rootViewController = tabBarViewController
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.hide()
            
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                print(error)
            }
        }
    }
        
    // MARK: - AuthViewControllerDelegate
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oauth2Storage.token else {
            print("Cannot get token from storage")
            return
        }
        fetchProfile(token)
    }
}
