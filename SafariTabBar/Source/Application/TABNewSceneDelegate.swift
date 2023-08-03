//
//  TABSceneDelegate.swift
//  DocumentTabBar
//
//  Created by Steven Troughton-Smith on 22/09/2021.
//  
//

import UIKit

class TABNewSceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else {
			fatalError("Expected scene of type UIWindowScene but got an unexpected type")
		}
		window = UIWindow(windowScene: windowScene)
		
		if let window = window {
			let tvc = TABTabbedViewController()
			tvc.viewControllerClassForNewTabs = TABMainViewController.self

			tvc.viewControllers = [TABMainViewController(address: "https://www.apple.com"), TABMainViewController(address: "https://developer.apple.com/visionos/"), TABMainViewController(address: "https://www.apple.com/ios/")]
			window.rootViewController = tvc
			
			window.makeKeyAndVisible()
		}
	}
}
