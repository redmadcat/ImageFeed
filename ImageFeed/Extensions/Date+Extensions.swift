//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 14.06.2025.
//

import Foundation

extension Date {
    var longDateString: String { DateFormatter.longDate.string(from: self) }
}

private extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

