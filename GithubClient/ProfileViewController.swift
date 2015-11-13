//
//  ProfileViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/11/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

	//icon by
	//http://www.flaticon.com/authors/bogdan-rosu
	
	@IBOutlet weak var avatarView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var joinedLabel: UILabel!
	@IBOutlet weak var followersLabel: UILabel!
	@IBOutlet weak var starredLabel: UILabel!
	@IBOutlet weak var followingLabel: UILabel!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	
	private var user:User?
	{
		didSet
		{
			if let user = user
			{
				nameLabel.text = user.name
				followersLabel.text = "\(user.followers)"
				starredLabel.text = "\(user.starred)"
				followingLabel.text = "\(user.following)"
				
				//build the date
				let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd"
				let date = dateFormatter.dateFromString(user.created.substringToIndex(user.created.startIndex.advancedBy(10)))
				if let date = date
				{
					dateFormatter.dateFormat = "MMM d, yyyy"
					let dateString = dateFormatter.stringFromDate(date)
					joinedLabel.text = "Joined \(dateString)"
				}
				
				//get the image
				let queue = dispatch_queue_create("image_dispatch_queue", nil)
				dispatch_async(queue)
				{
					let imageData = NSData(contentsOfURL: NSURL(string: user.avatar)!)
					
					dispatch_async(dispatch_get_main_queue())
					{
						if let imageData = imageData
						{
							self.avatarView.image = UIImage(data: imageData)
						}
						else
						{
							print("ERROR: failed to retrieve image at \(user.avatar)")
						}
					}
				}
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		spinner.startAnimating()
		GithubService.fetchUserInfo()
		{ (error, user) in
			if let error = error
			{
				print(error)
			}
			else if let user = user
			{
				self.user = user
			}
			self.spinner.stopAnimating()
		}
    }
}
