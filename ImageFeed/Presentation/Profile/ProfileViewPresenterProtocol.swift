//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 27.08.2025.
//

protocol ProfileViewPresenterProtocol: DisposableProtocol {
    var view: ProfileViewController? { get set }
    func didUpdateAvatarImage()
}
