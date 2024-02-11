//
//  NewsBrowserViewController.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import UIKit
import WebKit

class NewsBrowserViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView = WKWebView()

    var link: URL?

    override func loadView() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        openLink(url: link)
    }

    private func openLink(url: URL?) {
        guard let url = url else {
            return
        }
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            } else {
                decisionHandler(.allow)
                return
            }
        } else {
            decisionHandler(.allow)
            return
        }
    }
}
