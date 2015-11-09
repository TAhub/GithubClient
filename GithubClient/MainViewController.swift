//
//  MainViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/9/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	@IBAction func requestToken()
	{
		OAuthClient.shared.oauthRequest(["scope" : "email,user"])
	}
	
	@IBAction func printToken()
	{
		do
		{
			let token = try OAuthClient.shared.accessToken()
			print(token)
		}
		catch let error
		{
			print(error)
		}
	}
	
}
