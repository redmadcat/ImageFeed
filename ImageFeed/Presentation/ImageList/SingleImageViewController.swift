//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 17.06.2025.
//

import UIKit

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - @IBOutlet
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var scrollView: UIScrollView!
    
    // MARK: - Definition
    var fullImageUrl: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        setImage()
    }
    
    // MARK: - Private func
    private func setImage() {
        guard let fullImageUrl else { return }
        
        UIBlockingProgressHUD.show()
        let placeholderImage = UIImage(named: "Stub")
                   
        imageView.frame.size = UIScreen.main.bounds.size
        imageView.kf.setImage(with: URL(string: fullImageUrl), placeholder: placeholderImage) { [weak self] result in
            UIBlockingProgressHUD.hide()
            
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.image = imageResult.image
                self.imageView.frame.size = imageResult.image.size
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Не надо", style: .default, handler: nil)
        let repeatAction = UIAlertAction(title: "Повторить", style: .default, handler: { _ in
            self.setImage()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(repeatAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: - @IBAction
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton() {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        share.overrideUserInterfaceStyle = .dark
        present(share, animated: true, completion: nil)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SingleImageViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(UIViewController.devices, id: \.self) { deviceName in
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SingleImage").toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

