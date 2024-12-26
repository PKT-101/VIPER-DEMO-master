//
//  LoginModule.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import Foundation
import UIKit

protocol LoginModuleFlow: LoginFlowProtocol { //exit points from module, should be implemented by flow
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
        eventsHandler!.prepareData()
        viewRenderer?.renderView()
        return self
    }
    
    override func refreshModule() {
        prepareData()
    }
}

extension LoginModule: LoginModuleEventsHandler {
    
    func prepareData() {
        Huston.shared.operation(inProgress: true)
        DataManager.shared.fetchData { success in
            DispatchQueue.main.async {
                Huston.shared.renderStatusView(message: success ? "Login to manage your Favourite movies" : "Nothing to see. Failed to fetch movies")
                Huston.shared.operation(inProgress: false)
            }
        }
    }
    
    func refreshData() {}
    
    func pop() {}
    
    func executeLogin() {
        Flow.shared.executeLogin()
    }
    
    func useAsGuest() {
        Flow.shared.useAsGuest()
    }
}
