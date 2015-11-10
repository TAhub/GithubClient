//
//  PostTableViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/10/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {

	@IBOutlet weak var nameText: UITextField!
	@IBOutlet weak var descriptionText: UITextField!
	
	@IBAction func post()
	{
		if !nameText.text!.isEmpty
		{
			//TODO: post
			
			reset()
		}
	}
	
	@IBAction func reset()
	{
		nameText.text = ""
		descriptionText.text = ""
	}
}
