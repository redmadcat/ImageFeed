//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 22.08.2025.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: - Definition
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - WebViewPresenterProtocol
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        return authHelper.code(from: url)
    }
        
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
