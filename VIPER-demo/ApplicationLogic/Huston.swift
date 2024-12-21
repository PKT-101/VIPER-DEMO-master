//
//  Huston.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import Foundation
import UIKit
import SwiftUI

enum UserStatus {
    case unknown
    case guest
    case loggedIn
}

class Huston {
    
    static let shared = Huston()
    var userStatus = UserStatus.unknown
    
    func userLoggedIn() {
        userStatus = .loggedIn
    }
    
    func guestAccepted() {
        userStatus = .guest
    }
}

@MainActor class Flow {
    
    static let shared = Flow()
    private var window: UIWindow?
    private var operationStatus: OperationStatus?
    private var statusView: UIView?
    
    func start(window: UIWindow) {
        let module = LoginModule().prepareModule()
        DataManager.fetchData { success in
            DispatchQueue.main.async {
                if(success) {
                    self.renderStatusView(message: "Login to manage your Favourite movies")
                    (module as! LoginModule).initialCacheCompleted()
                } else {
                    self.renderStatusView(message: "Nothing to see. Failed to fetch movies")
                }
            }
        }
        self.window = window
        operationStatus = OperationStatus()
        renderStatusView(message: "Please wait while caching data from sever")
        (window.rootViewController! as! UINavigationController).viewControllers = [module]
    }
    
    func renderStatusView(message: String) {
        if((statusView?.superview) != nil) {
            statusView!.removeFromSuperview()
        }
        operationStatus?.status = message
        statusView = UIHostingController(rootView: StatusView(viewModel: operationStatus!)).view
        statusView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 50, width: UIScreen.main.bounds.size.width, height: 50)
        statusView?.backgroundColor = .clear
        self.window!.addSubview(statusView!)
    }
}

extension Flow: LoginModuleFlow {
    func executeLogin() {
        let module = WebModule().prepareModule()
        (window!.rootViewController! as! UINavigationController).viewControllers = [module]
        //renderStatusView(message: "Logon in progresss")
    }
    
    func useAsGuest() {
        print("Flow guest")
        Huston.shared.guestAccepted()
        //operationStatus?.status = "No access to your Favourite movies"
        renderStatusView(message: "No access to your Favourite movies")
    }
}

extension Flow: WebModuleFlow {
    func loginStatus(success: Bool) {
        var module: Module?
        if(success) {
            module = NowPlayingModule().prepareModule()
        } else {
            module = LoginModule().prepareModule()
        }
        (window!.rootViewController! as! UINavigationController).viewControllers = [module!]
    }
}
