//
//  LoginModule.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import Foundation
import UIKit

protocol LoginModuleFlow { //exit points from module, should be implemented by flow
    func executeLogin()
    func useAsGuest()
}

protocol LoginModuleInterface {
    func initialCacheCompleted()
}

class LoginViewModel: ObservableObject {
    @Published var buttonsDisbled: Bool
    
    init() {
        buttonsDisbled = true
    }
}

protocol LoginModuleEventsHandler { //user driven/external events handling
    func executeLogin()
    func useAsGuest()
}

protocol LoginModuleViewRenderer: ModuleView {} //request to render view for user

class LoginModule: Module {
    
    internal var viewRenderer: LoginModuleViewRenderer?
    internal var eventsHandler: LoginModuleEventsHandler?
    internal var viewModel: LoginViewModel?
    
    override func prepareModule() -> Module {
        eventsHandler = self
        viewRenderer = self
        viewModel = LoginViewModel()
        viewRenderer?.renderView()
        
        return self
    }
    
    override func returnToForeground() {
        print("oken")
        SessionAPI.getSession { result in
            
            print("User " + (result ? "logged in" : "rejected"))
        }
    }
}

extension LoginModule: LoginModuleEventsHandler {
    
    func executeLogin() {
        viewModel?.buttonsDisbled = true
        Flow.shared.renderStatusView(message: "Logon in progresss")
        SessionAPI.getSessionToken { token in
            Flow.shared.executeLogin()
        }
    }
    
    func useAsGuest() {
        Flow.shared.useAsGuest()
    }
}

extension LoginModule: LoginModuleInterface {
    func initialCacheCompleted() {
        viewModel?.buttonsDisbled = false
    }
}
