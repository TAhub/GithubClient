//
//  ButtonExtension.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/11/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

extension UIButton
{
	public func winterBorder()
	{
		layer.backgroundColor = UIColor.whiteColor().CGColor
		layer.borderWidth = 10.0
		layer.borderColor = UIColor.whiteColor().CGColor
		layer.cornerRadius = 10
	}
}