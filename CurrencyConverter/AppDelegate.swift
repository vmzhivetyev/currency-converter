//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 30/08/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		let window = UIWindow()
		let navigationController = UINavigationController()
		
		navigationController.viewControllers = [
			CurrencyConverterViewAssembly().createViewController()
		]

		self.window = window
		window.rootViewController = navigationController
		window.makeKeyAndVisible()

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {

	}

	func applicationDidEnterBackground(_ application: UIApplication) {

	}

	func applicationWillEnterForeground(_ application: UIApplication) {

	}

	func applicationDidBecomeActive(_ application: UIApplication) {

	}

	func applicationWillTerminate(_ application: UIApplication) {

	}

}
