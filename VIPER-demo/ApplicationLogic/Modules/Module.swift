//
//  Module.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 21/12/2024.
//

import UIKit

class Module: UIViewController, ModuleLifecycle {
    
    weak var tableView: UITableView?
    
    func prepareModule() -> Module? {
        exit(-1) // make sure that you do not forget to implement method in module :)
    }
    
    func refreshModule() {}
    
    func returnToForeground() { //application returned to foreground
        //optional method
    }
    
}

protocol ModuleLifecycle {
    func prepareModule() -> Module?
    func returnToForeground()
    func refreshModule()
}

protocol ModuleView {
    func renderView()
}

protocol ModuleEventsHandler {
    func prepareData()
    func refreshData()
    func pop()
}
