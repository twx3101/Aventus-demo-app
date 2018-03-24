//
//  AppDelegate.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 01/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//




import UIKit
import Firebase
import CapitoSpeechKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let settings = CAPSettings.getInstance()
        settings?.setAppVersion(AppDelegate.appVersionNumberDisplayString())
        settings?.silenceDetectionTime = 3.0
        
        let controller = CapitoController.getInstance()
        //"a2d65251-0fe4-476f-994d-5dce055f555f" test appkey
        controller?.setup(withID: "0848c593-9864-4205-bf86-4fb40c5b7744", host: "sysportal.test.a.cloud.capitosystems.com" , port: 443, useSSL: true)
        
        let status = controller?.connect()
        print("CapitoSpeechKit status: ", status)
        
        FirebaseApp.configure()
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        CapitoController.getInstance().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        let status = CapitoController.getInstance().connect()
        print(status!)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    class func appVersionNumberDisplayString() -> String {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let majorVersion = infoDictionary["CFBundleShortVersionString"],
            let minorVersion = infoDictionary["CFBundleVersion"] else {
                return ""
        }
        return "\(majorVersion).\(minorVersion)"
    }
}

