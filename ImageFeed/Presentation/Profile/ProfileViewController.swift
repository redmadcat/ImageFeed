//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 17.06.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var loginNameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var logoutButton: UIButton!
        
    @IBAction func didTapLogoutButton() {
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ProfileViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(UIViewController.devices, id: \.self) { deviceName in
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Profile").toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
