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


protocol WebModuleEventsHandler: ModuleEventsHandler {}

protocol WebModuleViewRenderer: ModuleView {}

class WebModule: Module {
    internal weak var viewRenderer: WebModuleViewRenderer?
    internal weak var eventsHandler: WebModuleEventsHandler?

    override func prepareModule() -> Module {
        moduleContext = (Flow.shared.dtoDictionary?.removeValue(forKey: DTO.DTO_MODULE_CONTEXT) as? ModuleContext)
        eventsHandler = self
        viewRenderer = self
        viewRenderer?.renderView()
    
        return self
    }

    override func returnToForeground() {
        print("oken")
        SessionAPI.shared.getSession { result in
            Flow.shared.loginStatus(success: result)
        }
    }
}

extension WebModule: WebModuleEventsHandler, WKNavigationDelegate {
    func prepareData() {}
    
    func refreshData() {}
    
    func pop() {}
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
