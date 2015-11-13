//
//  MainViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/9/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit
import WebKit

class MainViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var searchBox: UISearchBar!
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
			table.delegate = self
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

	func searchBarSearchButtonClicked(searchBar: UISearchBar)
	{
		if searchBar.text!.isSafeToSearch
		{
			spinner.startAnimating()
			
			//search for the given thing
			GithubService.fetchRepositories(searchBar.text!)
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
		}
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar)
	{
		searchBar.resignFirstResponder()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if let dest = segue.destinationViewController as? WebViewController, let cell = sender as? UITableViewCell
		{
			let index = table!.indexPathForCell(cell)!
			let repo = searchResults[index.row]
			dest.urlString = repo.homepage
		}
	}
	
	//MARK: table view data source
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = table.dequeueReusableCellWithIdentifier("repoCell")!
		cell.textLabel!.text = searchResults[indexPath.row].name
		cell.detailTextLabel!.text = searchResults[indexPath.row].owner.login
		return cell
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return searchResults.count
	}
	
	//MARK: table view delegate
	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
	{
		performSegueWithIdentifier("showWeb", sender: tableView.cellForRowAtIndexPath(indexPath)!)
		return nil
	}
}
