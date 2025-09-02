//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 26.08.2025.
//

import UIKit

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Definition
    weak var view: ProfileViewControllerProtocol?
    private let profileHelper: DisposableProtocol?
    private let profileLogoutService = ProfileLogoutService.shared
    
    init(profileHelper: DisposableProtocol) {
        self.profileHelper = profileHelper
    }
    
    // MARK: - ProfileViewPresenterProtocol
    func didUpdateAvatarImage() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
                        
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        view?.updateAvatarWith(imageUrl: imageUrl, placeholderImage: placeholderImage)
    }
            
    func didLogout() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Да", style: .default, handler: { _ in
            self.view?.dispose()
        })
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        guard let view = view as? UIViewController else { return }
        view.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - DisposableProtocol
    func dispose() {
        profileLogoutService.dispose()
        profileHelper?.dispose()
    }
}
