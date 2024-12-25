//
//  Flow.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 25/12/2024.
//  Copyright © 2024 Tootle. All rights reserved.
//

import Foundation
import UIKit

@MainActor class Flow {
    
    static let shared = Flow()
    private var window: UIWindow?
    
    func start(window: UIWindow) {
        self.window = window
        Huston.shared.renderStatusView(message: "Please wait while caching data from sever")
        setCurrentModule(module: LoginModule().prepareModule())
    }
    
    func execute(delegate: () -> Void) {
        Huston.shared.operation(inProgress: true)
        delegate()
        Huston.shared.operation(inProgress: false)
    }
    
    func setCurrentModule(module: Module) {
        (window!.rootViewController! as! UINavigationController).viewControllers = [module]
    }
}

extension Flow: LoginModuleFlow {
    func executeLogin() {
        setCurrentModule(module: WebModule().prepareModule())
        Huston.shared.renderStatusView(message: "Login in progresss")
    }
    
    func useAsGuest() {
        print("Flow guest")
        Huston.shared.guestAccepted()
        Huston.shared.renderStatusView(message: "No access to your Favourite movies")
    }
}

extension Flow: WebModuleFlow {
    func loginStatus(success: Bool) {
        var module: Module?
        if(success) {
            Huston.shared.userLoggedIn()
            module = NowPlayingModule().prepareModule()

        } else {
            module = LoginModule().prepareModule()
        }
        setCurrentModule(module: module!)
    }
}
