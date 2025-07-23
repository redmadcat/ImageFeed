//
//  LogHelper.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 23.07.2025.
//

public func log(_ item: Any, file: String = #file, function: String = #function, line: Int = #line) {
    print("\(item) called from \(function) \(file):\(line)")
}
