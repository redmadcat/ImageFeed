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
    
    // MARK: - DisposableProtocol
    func dispose() {
        profileLogoutService.dispose()
        profileHelper?.dispose()
    }
}
