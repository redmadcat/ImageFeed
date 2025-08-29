//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 24.07.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
                
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController") as? ImagesListViewController
        else {
            fatalError("Cannot load ImagesListViewController")
        }
        
        let imagesListPresenter = ImagesListViewPresenter()
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        let profileHelper = ProfileHelper()
        let profilePresenter = ProfileViewPresenter(profileHelper: profileHelper)
        let profileViewController = ProfileViewController()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "TabProfileActive"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
