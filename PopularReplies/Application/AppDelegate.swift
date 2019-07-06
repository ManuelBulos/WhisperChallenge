//
//  AppDelegate.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 27/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appController: AppController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appController = AppController(window: window)
        appController?.start()
        return true
    }
}
