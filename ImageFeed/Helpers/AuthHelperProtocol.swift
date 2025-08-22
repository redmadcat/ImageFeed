//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 22.08.2025.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
