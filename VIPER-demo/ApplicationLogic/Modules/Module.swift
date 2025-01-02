//
//  Module.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 21/12/2024.
//

import UIKit

protocol ModuleLifecycle {
    func prepareModule() -> Module?
    func returnToForeground()
    func refreshModule()
}

protocol ModuleView: AnyObject {
    func renderView()
}

protocol ModuleEventsHandler: AnyObject {
    func prepareData()
    func refreshData()
    func pop()
}

enum CheckPoint {
    case LoginEntryPoint
}

class ModuleContext {
    var moduleMode: Any?
    weak var flow: Flow?
    var checkPoint: CheckPoint?
    
    var completionBlock: (() -> (Void))?
    var popCompletionBlock: (() -> (Void))?
}

class Module: UIViewController, ModuleLifecycle {
    var moduleContext: ModuleContext?
    weak var tableView: UITableView?
    
    func prepareModule() -> Module? {
        exit(-1) // make sure that you do not forget to implement method in module :)
    }
    
    func refreshModule() {}
    
    func returnToForeground() { //application returned to foreground
        //optional method
    }
}


