//
//  AppDelegate.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 24..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirestoreManager.manager.setup()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let startVC = BuildsViewController()
        let nav = NavigationController(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        nav.setViewControllers([startVC], animated: false)

        window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        
        return true
    }


}

