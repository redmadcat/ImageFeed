//
//  LogHelper.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 23.07.2025.
//

public func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    print("\(message) called from \(function) \(file):\(line)")
}
