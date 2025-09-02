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
    
    func testDisposeCalls() {
        // given
        let viewController = ProfileViewControllerSpy()
        let profileHelper = ProfileHelperSpy()
        
        let presenter = ProfileViewPresenter(profileHelper: profileHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.dispose()
                                
        // then
        XCTAssertTrue(profileHelper.disposeCalled)
    }
}
