//
//  WebViewViewController+Extensions.swift
//  ImageFeed
//
//  Created by Roman Yaschenkov on 04.07.2025.
//

@preconcurrency import WebKit

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == Constants.authorizePath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == Constants.responseType })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
