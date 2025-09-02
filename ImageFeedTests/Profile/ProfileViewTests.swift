//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Roman Yaschenkov on 29.08.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testDidUpdateAvatarCalled() {
        // given
        let viewController = ProfileViewControllerSpy()
        let profileHelper = ProfileHelper()
        let presenter = ProfileViewPresenterSpy(profileHelper: profileHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.didUpdateAvatarImage()
        
        // then
        XCTAssertTrue(viewController.didUpdateAvatarCalled)
    }
    
    func testDidLogoutCalls() {
        // given
        let viewController = ProfileViewControllerSpy()
        let profileHelper = ProfileHelperSpy()
        let presenter = ProfileViewPresenterSpy(profileHelper: profileHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.didLogout()
                
        // then
        XCTAssertTrue(presenter.logoutCalled)
        XCTAssertTrue(viewController.disposeCalled)
        XCTAssertTrue(presenter.disposeCalled)
        XCTAssertTrue(profileHelper.disposeCalled)
    }
}
