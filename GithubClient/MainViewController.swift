//
//  MainViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/9/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {

	@IBOutlet weak var searchBox: UITextField!
	{
		didSet
		{
			searchBox.delegate = self
		}
	}
	
	@IBOutlet weak var table: UITableView!
	{
		didSet
		{
			table.dataSource = self
		}
	}
	
	private var searchResults = [Repository]()
	{
		didSet
		{
			if table != nil
			{
				table.reloadData()
			}
		}
	}
	
	@IBOutlet var spinner: UIActivityIndicatorView!
	
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		spinner.startAnimating()
		
		//search for the given thing
		GithubService.fetchRepositories(textField.text!)
		{ (error, results) in
			if let error = error
			{
				print(error)
			}
			else
			{
				self.searchResults = results ?? [Repository]()
			}
			self.spinner.stopAnimating()
		}
		
		return true
	}
	
	func textFieldDidEndEditing(textField: UITextField)
	{
		textField.resignFirstResponder()
	}
	
	//MARK: table view data source
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = table.dequeueReusableCellWithIdentifier("repoCell")!
		cell.textLabel!.text = searchResults[indexPath.row].name
		cell.detailTextLabel!.text = searchResults[indexPath.row].url
		return cell
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return searchResults.count
	}
}
