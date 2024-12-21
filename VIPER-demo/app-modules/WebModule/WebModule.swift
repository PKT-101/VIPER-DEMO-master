//
//  WebModule.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 21/12/2024.
//

import Foundation
import UIKit
import WebKit

protocol WebModuleFlow { // exit points from module
    func loginStatus(success: Bool)
}


protocol WebModuleEventsHandler {
    func userLoggedIn()
}

protocol WebModuleViewRenderer: ModuleView {}

class WebModule: Module {
    internal var viewRenderer: WebModuleViewRenderer?
    internal var eventsHandler: WebModuleEventsHandler?

    override func prepareModule() -> Module {
        eventsHandler = self
        viewRenderer = self
        viewRenderer?.renderView()
    
        return self
    }

    override func returnToForeground() {
        print("oken")
        SessionAPI.getSession { result in
            Flow.shared.loginStatus(success: result)
        }
    }
}

extension WebModule: WebModuleEventsHandler, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func userLoggedIn() {
         
    }
}
