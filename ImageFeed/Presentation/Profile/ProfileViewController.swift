//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 17.06.2025.
//

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    // MARK: - Definition
    private let profile = ProfileService.shared.profile    
    private var profileImageServiceObserver: NSObjectProtocol?
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        presenter?.didUpdateAvatarImage()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ){ [weak self] _ in
                guard let self else { return }
                presenter?.didUpdateAvatarImage()
            }
    }
    
    // MARK: - ProfileViewControllerProtocol
    func updateAvatarWith(imageUrl: URL, placeholderImage: UIImage?) {
        guard let imageView = view.subviews.compactMap({$0 as? UIImageView}).first else { return }
        
        imageView.setImageWith(imageUrl: imageUrl, placeholderImage: placeholderImage, cornerRadius: 35)
    }
    
    // MARK: - DisposableProtocol
    func dispose() {
        presenter?.dispose()
    }
            
    // MARK: - Private func
    private func configureLayout() {
        view.backgroundColor = .ypBlack
        
        let logoutButton = getLogoutButton()
        let profileImageView = getProfileImageView()
        let profileNameLabel = getProfileNameLabel()
        let profileLoginLabel = getProfileLoginLabel()
        let profileDescriptionLabel = getProfileDescriptionLabel()
        
        view.addSubview(logoutButton)
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(profileLoginLabel)
        view.addSubview(profileDescriptionLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1.0 / 1.0),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
                        
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            profileLoginLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            profileLoginLabel.leadingAnchor.constraint(equalTo: profileNameLabel.leadingAnchor),
            profileLoginLabel.trailingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor),
            
            profileDescriptionLabel.topAnchor.constraint(equalTo: profileLoginLabel.bottomAnchor, constant: 8),
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: profileNameLabel.leadingAnchor),
            profileDescriptionLabel.trailingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor)
        ])
    }
    
    private func getProfileImageView() -> UIView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .ypGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func getLogoutButton() -> UIView {
        let logoutButton = UIButton(type: .custom)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setImage(UIImage(named: "Logout") ?? UIImage(), for: .normal)
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        logoutButton.tintColor = .ypRed
        logoutButton.accessibilityIdentifier = "Logout"
        return logoutButton
    }
    
    private func getProfileNameLabel() -> UIView {
        UILabel(
            text: profile?.name ?? "",
            textColor: UIColor.ypWhite,
            font:.systemFont(ofSize: 23, weight: .semibold))
    }
    
    private func getProfileLoginLabel() -> UIView {
        UILabel(text: profile?.loginName ?? "", textColor: UIColor.ypGray)
    }
    
    private func getProfileDescriptionLabel() -> UIView {
        UILabel(text: profile?.bio ?? "", textColor: UIColor.ypWhite)
    }
        
    // MARK: - Button actions
    @objc private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Да", style: .default, handler: { _ in
            self.dispose()
        })
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ProfileViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(UIViewController.devices, id: \.self) { deviceName in
            ProfileViewController().toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
