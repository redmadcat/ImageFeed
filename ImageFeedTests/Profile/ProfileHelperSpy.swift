//
//  ProfileHelperSpy.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 29.08.2025.
//

import ImageFeed

final class ProfileHelperSpy: DisposableProtocol {
    var disposeCalled: Bool = false
    
    func dispose() {
        disposeCalled = true
    }
}
