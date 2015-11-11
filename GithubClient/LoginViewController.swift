//
//  LoginViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/10/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	@IBOutlet weak var messageLabel: UILabel!
	
	var message:String?
	{
		didSet
		{
			messageLabel.text = label
		}
	}

	@IBAction func loginToGithub()
	{
		OAuthClient.shared.oauthRequest(["scope" : "user,repo"])
	}
}
