//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 29.08.2025.
//

import ImageFeed
import UIKit
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    var didUpdateAvatarCalled: Bool = false
    var disposeCalled: Bool = false
    
    func updateAvatarWith(imageUrl: URL, placeholderImage: UIImage?) {
        didUpdateAvatarCalled = true
    }
    
    func dispose() {
        disposeCalled = true
        presenter?.dispose()
    }
}
