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
    static let authorizePath = "/oauth/authorize/native"
    static let responseType = "code"
    static let grantType = "authorization_code"
    static let baseAPIURL = "https://api.unsplash.com"
    static let baseURL = "https://unsplash.com"
    static let profileImageRequest = baseAPIURL + "/users/"
    static let profileRequest = baseAPIURL + "/me"
    static let photosRequest = baseAPIURL + "/photos"
    static let tokenRequest = baseURL + "/oauth/token"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
