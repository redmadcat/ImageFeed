//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 26.08.2025.
//

import UIKit
import Foundation
import Kingfisher

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewController?
    private var profileHelper: DisposableProtocol?
    
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
        profileHelper?.dispose()
    }
}
