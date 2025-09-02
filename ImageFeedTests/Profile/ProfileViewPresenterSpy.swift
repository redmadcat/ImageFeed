//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 29.08.2025.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var disposeCalled: Bool = false
    var logoutCalled: Bool = false
    private var profileHelper: DisposableProtocol?
    
    init(profileHelper: DisposableProtocol) {
        self.profileHelper = profileHelper
    }
    
    func didUpdateAvatarImage() {
        view?.updateAvatarWith(imageUrl: URL(string: "/fake/path")!, placeholderImage: nil)
    }
    
    func didLogout() {
        logoutCalled = true
        view?.dispose()
    }
    
    func dispose() {
        disposeCalled = true
        profileHelper?.dispose()
    }
}
