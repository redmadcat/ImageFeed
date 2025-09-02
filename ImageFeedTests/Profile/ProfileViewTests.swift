//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Roman Yaschenkov on 29.08.2025.
//

@testable import ImageFeed
import XCTest
import UIKit

final class ProfileViewTests: XCTestCase {
    
    func testDidUpdateAvatarCalled() {
        // given
        let viewController = ProfileViewController()
        let profileHelper = ProfileHelper()
        let presenter = ProfileViewPresenterSpy(profileHelper: profileHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.didUpdateAvatarCalled)
    }
    
    func testProfileHelperDisposeCalls() {
        // given
        let profileHelper = ProfileHelperSpy()
        let presenter = ProfileViewPresenter(profileHelper: profileHelper)
        
        // when
        presenter.dispose()
                                
        // then
        XCTAssertTrue(profileHelper.disposeCalled)
    }
    
    func testProfileViewPresenterDisposeCalls() {
        // given
        let viewController = ProfileViewController()
        let profileHelper = ProfileHelper()
        let presenter = ProfileViewPresenterSpy(profileHelper: profileHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController.dispose()
        
        // then
        XCTAssertTrue(presenter.disposeCalled)
    }
    
    func testResetRootViewControllerCalls() {
        // given
        let profileHelper = ProfileHelper()
        let presenter = ProfileViewPresenter(profileHelper: profileHelper)
        
        // when
        presenter.dispose()
                                
        // then
        XCTAssertTrue(UIApplication.shared.windows.first?.rootViewController is SplashViewController)
    }
}
