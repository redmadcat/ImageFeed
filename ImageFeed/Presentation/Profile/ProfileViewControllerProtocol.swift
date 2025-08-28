//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 28.08.2025.
//

import UIKit
import Foundation

protocol ProfileViewControllerProtocol: DisposableProtocol {
    func updateAvatarWith(imageUrl: URL, placeholderImage: UIImage?)
}
