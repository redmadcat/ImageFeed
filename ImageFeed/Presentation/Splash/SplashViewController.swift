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
    private let oauth2Storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureLayout()

        if let token = oauth2Storage.token {
            fetchProfile(token)
        } else {
            presentAuthViewController()
        }
    }
    
    // MARK: - Private func
    private func configureLayout() {
        view.backgroundColor = .ypBlack
        
        let imageView = getSplashImageView()
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(
            withIdentifier: "AuthViewController") as? AuthViewController else {
            fatalError("cannot get AuthViewController at identifier")
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
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
                log(error.localizedDescription)
            }
        }
    }
    
    private func getSplashImageView() -> UIView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SplashScreenLogo")
        return imageView
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

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SplashViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(UIViewController.devices, id: \.self) { deviceName in
            SplashViewController().toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
