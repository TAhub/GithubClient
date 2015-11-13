//
//  UserViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/12/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var collection: UICollectionView!
	{
		didSet
		{
			collection.dataSource = self
			collection.collectionViewLayout = UsersFlowLayout()
		}
	}
	@IBOutlet weak var searchBar: UISearchBar!
	{
		didSet
		{
			searchBar.delegate = self
		}
	}
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	
	private var searchResults = [User]()
	{
		didSet
		{
			collection.reloadData()
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController!.delegate = self
	}
	
	let anim = UserPop()
	func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return anim
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if let dest = segue.destinationViewController as? UserDetailViewController, let sender = sender as? UserCollectionViewCell
		{
			let indexPath = collection.indexPathForCell(sender)!
			if let image = sender.image.image
			{
				dest.userImage = image
			}
			else
			{
				//mark the view controller so that it will be handed the image once it's loaded
				giveImageTo = dest
			}
			dest.user = searchResults[indexPath.row]
		}
	}
	
	private var giveImageTo:UserDetailViewController?
	
	//MARK: search bar delegate
	func searchBarSearchButtonClicked(searchBar: UISearchBar)
	{
		if searchBar.text!.isSafeToSearch
		{
			spinner.startAnimating()
			
			//search for the given thing
			GithubService.fetchUsers(searchBar.text!)
				{ (error, results) in
					if let error = error
					{
						print(error)
					}
					else
					{
						self.searchResults = results ?? [User]()
					}
					self.spinner.stopAnimating()
			}
		}
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar)
	{
		searchBar.resignFirstResponder()
	}
	
	//MARK: collection view data source
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let cell = collection.dequeueReusableCellWithReuseIdentifier("userCell", forIndexPath: indexPath) as! UserCollectionViewCell
		cell.winterBorder()
		
		//get the avatar image
		cell.image.image = nil
		let avatar = searchResults[indexPath.row].avatar
		let queue = dispatch_queue_create("image_dispatch_queue", nil)
		dispatch_async(queue)
		{
			let imageData = NSData(contentsOfURL: NSURL(string: avatar)!)
			
			dispatch_async(dispatch_get_main_queue())
			{
				if let imageData = imageData
				{
					cell.image.image = UIImage(data: imageData)
					
					//also pass on the image to the detail view controller, if it's here
					//this only matters if they click on a cell before its image loads
					if let giveImageTo = self.giveImageTo
					{
						if giveImageTo.user!.avatar == avatar
						{
							giveImageTo.userImage = cell.image!.image
							self.giveImageTo = nil
						}
					}
				}
				else
				{
					print("ERROR: failed to retrieve image at \(avatar)")
				}
			}
		}
		
		return cell
	}
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return searchResults.count
	}
}
