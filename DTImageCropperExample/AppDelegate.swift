//
//  AppDelegate.swift
//  DTImageCropperExample
//
//  Created by David Thorn on 28.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import DTImageCropper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = DTImageCropperViewController.init()
        vc.startImage = UIImage.init(named: "car")
        
        let nav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return true
    }

    

}

