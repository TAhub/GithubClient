//
//  MainViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/9/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var searchBox: UITextField!
	{
		didSet
		{
			searchBox.delegate = self
		}
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		//search for the given thing
		GithubService.fetchRepositories(textField.text!)
		{ (error, results) in
			if let error = error
			{
				print(error)
			}
			else
			{
				print(results)
			}
		}
		
		return true
	}
	
	func textFieldDidEndEditing(textField: UITextField)
	{
		textField.resignFirstResponder()
	}
}
