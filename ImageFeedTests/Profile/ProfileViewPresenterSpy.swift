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
    var didUpdateAvatarCalled: Bool = false
    var disposeCalled: Bool = false
    
    private var profileHelper: DisposableProtocol?
    
    init(profileHelper: DisposableProtocol) {
        self.profileHelper = profileHelper
    }
    
    func didUpdateAvatarImage() {
        didUpdateAvatarCalled = true
    }
    
    func didLogout() {
        
    }
    
    func dispose() {
        disposeCalled = true
    }
}
