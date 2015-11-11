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
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	
	@IBAction func post()
	{
		if !nameText.text!.isEmpty
		{
			spinner.startAnimating()
			GithubService.postRepository(nameText.text!, description: descriptionText.text ?? "")
			{ (error) in
				if let error = error
				{
					print(error)
				}
				self.reset()
				self.spinner.stopAnimating()
			}
		}
	}
	
	@IBAction func reset()
	{
		nameText.text = ""
		descriptionText.text = ""
	}
}
