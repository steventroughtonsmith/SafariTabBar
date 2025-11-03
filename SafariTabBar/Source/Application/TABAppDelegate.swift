//
//  TABAppDelegate.swift
//  DocumentTabBar
//
//  Created by Steven Troughton-Smith on 22/09/2021.
//  
//

import UIKit

extension UIUserInterfaceIdiom {
	static let reality = UIUserInterfaceIdiom.vision
}

@UIApplicationMain
class TABAppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		if options.userActivities.first?.activityType == "com.highcaffeinecontent.test" {
			return UISceneConfiguration(name: "Secondary", sessionRole: .windowApplication)
		}
		
		return UISceneConfiguration(name: "Default Configuration", sessionRole: .windowApplication)
	}
}
