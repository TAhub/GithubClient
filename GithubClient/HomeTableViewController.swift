//
//  HomeTableViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/11/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

	@IBOutlet weak var spinner: UIActivityIndicatorView!
	
	
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		spinner.startAnimating()
		GithubService.fetchMyRepositories()
		{ (error, repos) in
			if let error = error
			{
				print(error)
			}
			else if let repos = repos
			{
				self.repos = repos
			}
			self.spinner.stopAnimating()
		}
	}

    // MARK: - Table view data source
	private var repos = [Repository]()
	{
		didSet
		{
			tableView.reloadData()
		}
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        return repos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
		cell.textLabel!.text = repos[indexPath.row].name
        return cell
    }
}
