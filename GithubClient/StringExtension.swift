//
//  StringExtension.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/12/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import Foundation

extension String
{
	var isSafeToSearch:Bool
	{
		//no searching for empty stuff
		if isEmpty
		{
			return false
		}
		
		//no searching for invalid characters
		do
		{
			let regex = try NSRegularExpression(pattern: "[^0-9a-zA-Z]", options: NSRegularExpressionOptions())
			return regex.numberOfMatchesInString(self, options: NSMatchingOptions(), range: NSMakeRange(0, characters.count)) == 0
		}
		catch _
		{
			//it threw an exception, so it's probably not safe
			return false
		}
	}
}