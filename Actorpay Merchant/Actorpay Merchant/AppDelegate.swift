//
//  AppDelegate.swift
//  Actorpay Merchant
//
//  Created by iMac on 09/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let google_map_key = "AIzaSyDhMau_8Eah9KaloP_NWaBhDjvryMlzcD0"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey(google_map_key)
        GMSServices.provideAPIKey(google_map_key)
        IQKeyboardManager.shared.enable = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setupNavigation() {
        if AppManager.shared.token.count == 0 {
            let newVC = self.storyboard.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
        }else{
            let newVC = self.storyboard.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
        }
    }
}

