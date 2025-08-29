//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 28.08.2025.
//

import UIKit
import Foundation

public protocol ProfileViewControllerProtocol: AnyObject, DisposableProtocol {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatarWith(imageUrl: URL, placeholderImage: UIImage?)
}
