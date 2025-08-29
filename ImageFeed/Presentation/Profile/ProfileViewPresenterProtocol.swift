//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 27.08.2025.
//

public protocol ProfileViewPresenterProtocol: DisposableProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func didUpdateAvatarImage()
}
