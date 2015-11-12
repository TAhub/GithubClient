//
//  UserDetailViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/12/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

	var user:User!
	var userImage:UIImage!
	{
		didSet
		{
			trySetup()
		}
	}
	
	@IBOutlet weak var backButton: UIButton!
	{
		didSet
		{
			backButton.winterBorder()
		}
	}

	@IBAction func backAction()
	{
		navigationController!.popViewControllerAnimated(true)
	}
	
	
	@IBOutlet weak var avatarView: UIImageView!
	
	@IBOutlet weak var borderView: UIView!
	{
		didSet
		{
			borderView.winterBorder()
		}
	}

	@IBOutlet weak var nameLabel: UILabel!
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		trySetup()
	}
	
	private func trySetup()
	{
		if avatarView != nil && userImage != nil
		{
			avatarView.image = userImage
		}
		if nameLabel != nil && user != nil
		{
			nameLabel.text = user.name
		}
	}
}
