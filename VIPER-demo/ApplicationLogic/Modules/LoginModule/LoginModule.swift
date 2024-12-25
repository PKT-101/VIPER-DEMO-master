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


protocol LoginModuleEventsHandler: ModuleEventsHandler { //user driven/external events handling
    func executeLogin()
    func useAsGuest()
}

protocol LoginModuleViewRenderer: ModuleView {} //request to render view for user

class LoginModule: Module {
    
    internal var viewRenderer: LoginModuleViewRenderer?
    internal var eventsHandler: LoginModuleEventsHandler?
    
    override func prepareModule() -> Module {
        eventsHandler = self
        viewRenderer = self
        viewRenderer?.renderView()
        
        eventsHandler!.prepareData()
        return self
    }
}

extension LoginModule: LoginModuleEventsHandler {
    
    func prepareData() {
        Huston.shared.operation(inProgress: true)
        DataManager.fetchData { success in
            DispatchQueue.main.async {
                Huston.shared.renderStatusView(message: success ? "Login to manage your Favourite movies" : "Nothing to see. Failed to fetch movies")
                Huston.shared.operation(inProgress: false)
            }
        }
    }
    
    func executeLogin() {
        Huston.shared.operation(inProgress: true)
        Huston.shared.renderStatusView(message: "Logon in progresss")
        SessionAPI.getSessionToken { token in
            if(token != nil) {
                Flow.shared.execute {
                    Flow.shared.executeLogin()
                }
            } else {
                Huston.shared.operation(inProgress: false)
            }
        }
    }
    
    func useAsGuest() {
        Flow.shared.useAsGuest()
    }
}
