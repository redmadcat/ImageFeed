//
//  Constant.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 03.07.2025.
//

import Foundation

enum Constants {
    static let accessKey = "S1vOBH3t9F-vkPrnoTDLH6Or1xAH5HwYbIkMp5KAUMo"
    static let secretKey = "RRY4w55Pi_xQKxI5MwYog2efObLWumzA1D1GT0miQW4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let responseType = "code"
    static let authorizePath = "/oauth/authorize/native"
}


