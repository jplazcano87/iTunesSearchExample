//
//  AppDelegate.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/20/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let searchView = SearchListWireFrame.createSearchModule()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = searchView
        window?.makeKeyAndVisible()
        return true
    }
}
