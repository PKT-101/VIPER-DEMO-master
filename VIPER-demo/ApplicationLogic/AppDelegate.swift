//
//  AppDelegate.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        let font = UIFont(name: "AmericanTypewriter-Bold", size: 15)
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemRed, NSAttributedString.Key.font : font as Any]
        navigationBarAppearance.backgroundColor = UIColor.systemYellow
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        let backImage = UIImage(named: "BackButton")?.withRenderingMode(.alwaysOriginal)
        navigationController.navigationBar.backIndicatorImage = backImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage
            
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemRed,
            NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter-Bold", size: 15)!
        ], for: .normal)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemRed,
            NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter-Bold", size: 15)!
        ], for: .highlighted)
        
        let frame = UIApplication.shared.statusBarFrame
        let backview = UIView(frame: frame)
        backview.backgroundColor = UIColor.systemYellow
        window!.addSubview(backview)
        
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        Huston.shared.setup(window: window!)
        Flow.shared.start(window: window!)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("return to app")
        ((window?.rootViewController as! UINavigationController).viewControllers.last as! Module).returnToForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}


