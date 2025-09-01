//
//  XCUIElement+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 01.09.2025.
//

import XCTest

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
}
