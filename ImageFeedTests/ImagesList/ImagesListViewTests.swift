//
//  ImagesListViewTests.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 31.08.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    
    func testDidLoadCalled() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
                        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.didLoadCalled)
    }
    
    func testDisposeCalls() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController.dispose()
                
        // then
        XCTAssertTrue(presenter.disposeCalled)
    }
}
