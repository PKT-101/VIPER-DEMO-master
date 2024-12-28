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


protocol WebModuleEventsHandler: AnyObject {
    func userLoggedIn()
}

protocol WebModuleViewRenderer: AnyObject, ModuleView {}

class WebModule: Module {
    internal weak var viewRenderer: WebModuleViewRenderer?
    internal weak var eventsHandler: WebModuleEventsHandler?

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
