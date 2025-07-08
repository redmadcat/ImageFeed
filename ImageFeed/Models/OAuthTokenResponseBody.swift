//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 04.07.2025.
//

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
