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
			messageLabel.text = message
		}
	}
	
	@IBOutlet weak var loginButton: UIButton!
	{
		didSet
		{
			//give the login button a pretty border
			loginButton.layer.backgroundColor = UIColor.whiteColor().CGColor
			loginButton.layer.borderWidth = 10.0
			loginButton.layer.borderColor = UIColor.whiteColor().CGColor
			loginButton.layer.cornerRadius = 10
		}
	}

	@IBAction func loginToGithub()
	{
		killFlakes = true
		OAuthClient.shared.oauthRequest(["scope" : "user,repo"])
	}
	
	
	//MARK: dumb animation
	private var killFlakes:Bool = false
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
		{
			while (!self.killFlakes)
			{
				usleep(33000)
				dispatch_async(dispatch_get_main_queue())
				{
					self.addSnowflake()
				}
			}
		}
	}
	private func addSnowflake()
	{
		//pick the image
		//I got the snowflake clip art from
		//http://www.artsviewchildrenstheatre.com/wp-content/uploads/2013/05/blue-snowflake-600x600.png
		//http://www.maynineteen.co.uk/wp-content/uploads/2013/11/snowflake-clipart.png
		//http://images.clipartpanda.com/snowflake-clipart-outline-5673-snowflake-design.png
		//but I edited them
		
		
		var image:UIImage?
		let pick = arc4random_uniform(3)
		switch(pick)
		{
		case 0: image = UIImage(named: "snowflake1.png")
		case 1: image = UIImage(named: "snowflake2.png")
		case 2: image = UIImage(named: "snowflake3.png")
		default: break
		}
		
		//make the snowflake
		let snowflake = UIImageView(image: image)
		view.addSubview(snowflake)
		snowflake.sendSubviewToBack(view)
		
		//get the properties of the animation
		let xStart = CGFloat(arc4random_uniform(90)) * 0.02 + 0.1
		let duration = 6.5
		let rotateConst:CGFloat = CGFloat(arc4random_uniform(360))
		let rotateConst2:CGFloat = CGFloat(arc4random_uniform(360))
		
		//position the snowflake
		//I tried to do this with constraints earlier, but it wasn't working
		//while doing it with positions takes like three lines of code and works perfectly
		//it just looks weird if you rotate the screen
		snowflake.center.x = xStart * self.view.bounds.width
		snowflake.center.y = -30
		snowflake.transform = CGAffineTransformMakeRotation((rotateConst2 * CGFloat(M_PI)) / 180.0)
		
		//finally, add the animation
		UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations:
		{
			snowflake.center.y = self.view.bounds.height + 20

			//rotate it, in addition to moving it
			snowflake.transform = CGAffineTransformMakeRotation((rotateConst * CGFloat(M_PI)) / 180.0)
		})
		{ (success) in
			
			snowflake.removeFromSuperview()
		}
	}
}