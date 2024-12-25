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
    
    private var window: UIWindow?
    private var statusView: UIView?
    private var operationStatus: OperationStatus?
    private var progressIndicator:  ProgressIndicator?
    
    var userStatus = UserStatus.unknown
    
    @MainActor func setup(window: UIWindow) {
        self.window = window

        operationStatus = OperationStatus()
        progressIndicator = ProgressIndicator(text: "")
        self.window!.addSubview(progressIndicator!)
        progressIndicator?.isHidden = true
    }
    
    func userLoggedIn() {
        userStatus = .loggedIn
    }
    
    func guestAccepted() {
        userStatus = .guest
    }
    
    @MainActor func renderStatusView(message: String) {
        if((statusView?.superview) != nil) {
            statusView!.removeFromSuperview()
        }
        operationStatus?.status = message
        statusView = UIHostingController(rootView: StatusView(viewModel: operationStatus!)).view
        statusView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 50, width: UIScreen.main.bounds.size.width, height: 50)
        statusView?.backgroundColor = .clear
        self.window!.addSubview(statusView!)
        self.window!.bringSubviewToFront(progressIndicator!)
    }
    
    @MainActor func operation(inProgress: Bool) {
        progressIndicator?.isHidden = !inProgress
    }
}
