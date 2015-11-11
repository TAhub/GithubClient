//
//  AppDelegate.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/9/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		do
		{
			try OAuthClient.shared.accessToken()
		}
		catch _
		{
			//you don't have a token, so go to the login screen
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewControllerWithIdentifier("LoginController")
			window!.rootViewController = controller
		}
		
		return true
	}
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
	{
		//retrieve a token
		OAuthClient.shared.tokenRequestWithCallback(url)
		{ (success) in
			if success
			{
				//you're done logging in, so redirect to the real initial view controller
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let controller = storyboard.instantiateInitialViewController()
				self.window!.rootViewController = controller
			}
			else
			{
				//set the message in the login screen to show you failed
				if let loginScreen = self.window!.rootViewController as? LoginViewController
				{
					loginScreen.message = "Failed to retrieve a token. Sorry, you can't go on!"
				}
			}
		}
		
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

