//
//  WebModuleView.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 21/12/2024.
//

import SwiftUI
import WebKit

extension WebModule: WebModuleViewRenderer {
    
    func renderView() {
        self.view.backgroundColor = UIColor.white
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width:0, height: 0))
        webView.navigationDelegate = self
            self.view.addSubview(webView)
            
        if let url = URL (string: "https://www.themoviedb.org/authenticate/" + SessionAPI.token!) {
            let requestObj = URLRequest(url: url)
            webView.load(requestObj)
        }
    }
}
