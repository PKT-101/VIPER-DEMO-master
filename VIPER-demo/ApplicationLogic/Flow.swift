//
//  Flow.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 25/12/2024.
//  Copyright © 2024 Tootle. All rights reserved.
//

import Foundation
import UIKit

protocol PopFlowProtocol {
    func pop()
}

protocol LoginFlowProtocol {
    func executeLogin()
}

@MainActor class Flow {
    
    static let shared = Flow()
    private var window: UIWindow?
    private var previousModule: Module?
    
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
        var viewControllers = (window!.rootViewController! as! UINavigationController).viewControllers
        viewControllers.append(module)
        (window!.rootViewController! as! UINavigationController).setViewControllers(viewControllers, animated: true)
    }
}

extension Flow: LoginModuleFlow {
    func executeLogin() {
        previousModule = ((window!.rootViewController! as! UINavigationController).viewControllers.last as! Module)
        Huston.shared.operation(inProgress: true)
        SessionAPI.getSessionToken { token in
            if(token != nil) {
                Flow.shared.execute {
                    self.setCurrentModule(module: WebModule().prepareModule())
                    Huston.shared.renderStatusView(message: "Login in progresss")
                }
            } else {
                Huston.shared.operation(inProgress: false)
            }
        }
    }
    
    func useAsGuest() {
        Huston.shared.guestAccepted()
        setCurrentModule(module: NowPlayingModule().prepareModule())
        Huston.shared.renderStatusView(message: "No access to your Favourite movies")
    }
}

extension Flow: WebModuleFlow {
    func loginStatus(success: Bool) {
        var module = previousModule
        if(success) {
            Huston.shared.userLoggedIn()
            if(previousModule is LoginModule) {
                module = NowPlayingModule().prepareModule()
                let loginModule = (window!.rootViewController! as! UINavigationController).viewControllers.last
                (window!.rootViewController! as! UINavigationController).setViewControllers([module!, loginModule!], animated: false)
            } else {
                (module! as! ModuleEventsHandler).refreshData()
            }
        }
        (window!.rootViewController! as! UINavigationController).popViewController(animated: true)
    }
}

extension Flow: NowPlayingModuleFlow {
    func showMovieDetails(id: Int) {
        let module = MovieDetailsModule()
        module.setMovie(id: id)
        setCurrentModule(module: module.prepareModule())
    }
}

extension Flow: PopFlowProtocol {
    func pop() {
        (window!.rootViewController! as! UINavigationController).popViewController(animated: true)
    }
}
