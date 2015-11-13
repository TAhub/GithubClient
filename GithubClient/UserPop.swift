//
//  UserPop.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/12/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class UserPop: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate
{
	@objc func animateTransition(transitionContext: UIViewControllerContextTransitioning)
	{
		let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		let container = transitionContext.containerView()!
		let bounds = UIScreen.mainScreen().bounds
		
		let colorRect = UIView(frame: bounds)
		colorRect.backgroundColor = UIColor.blueColor()
		colorRect.alpha = 0
		container.addSubview(colorRect)
		
		//fade the color rect in
		UIView.animateWithDuration(transitionDuration(transitionContext) / 2, animations:
		{
			colorRect.alpha = 1
		})
		{ (success) in
			//add the next view
			to.view.alpha = 0
			container.addSubview(to.view)
			
			//fade the next view in
			UIView.animateWithDuration(self.transitionDuration(transitionContext) / 2, animations:
			{
				to.view.alpha = 1
			})
			{ (success) in
				//it's over!
				transitionContext.completeTransition(true)
				from.view.alpha = 0
			}
		}
	}
	
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}
	
	@objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
	{
		return 2.5
	}
}