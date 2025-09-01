//
//  ImagesListViewTests.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 31.08.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    
    func testUpdateTableViewAnimated() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
                
        // when
        presenter.view?.updateTableViewAnimated()
        
        // then
        XCTAssertTrue(viewController.didUpdateTableViewAnimatedCalled)
    }
}
