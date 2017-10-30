//
//  AppDelegate.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var appCoordinator: AppCoordinator!
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.appCoordinator = AppCoordinator(window: window)
    self.window = window
    self.appCoordinator.start()
    window.makeKeyAndVisible()
    
    return true
  }
}
