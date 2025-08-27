//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 26.08.2025.
//

final class ProfileViewPresenter: DisposableProtocol {
    private var profileHelper: DisposableProtocol?
    
    init(profileHelper: DisposableProtocol) {
        self.profileHelper = profileHelper
    }
    
    // MARK: - DisposableProtocol
    func dispose() {
        profileHelper?.dispose()
    }
}
