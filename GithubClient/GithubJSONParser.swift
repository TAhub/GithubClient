//
//  GithubJSONParser.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/10/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import Foundation

class GithubJSONParser
{
	class func reposFromNSData(data: NSData) -> [Repository]?
	{
		do
		{
			//this syntax is kind of weird
			//because there are multiple different formats they use for passing back repositories
			//depending on if you search, or look at a user's results
			let deserialized = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
			var rootObject:[[String : AnyObject]]?
			if let rootObjectDict = deserialized as? [String : AnyObject], let rootObjectDictArray = rootObjectDict["items"] as? [[String : AnyObject]]
			{
				rootObject = rootObjectDictArray
			}
			else if let rootObjectArray = deserialized as? [[String : AnyObject]]
			{
				rootObject = rootObjectArray
			}
			
			if let rootObject = rootObject
			{
				var repos = [Repository]()
				for item in rootObject
				{
					if let repo = repoFromJSON(item)
					{
						repos.append(repo)
					}
				}
				return repos
			}
		}
		catch
		{
			//there was an exception
		}
		return nil
	}
	
	class func repoFromJSON(json: [String : AnyObject]) -> Repository?
	{
		if let name = json["name"] as? String, let fullName = json["full_name"] as? String, let url = json["url"] as? String, let ownerJSON = json["owner"] as? [String : AnyObject], let owner = ownerFromJSON(ownerJSON), let id = json["id"] as? Int
		{
			return Repository(name: name, fullName: fullName, url: url, id: id, owner: owner)
		}
		return nil
	}
	
	class func ownerFromJSON(json: [String : AnyObject]) -> Owner?
	{
		if let login = json["login"] as? String, let id = json["id"] as? Int, let url = json["url"] as? String, let avatar_url = json["avatar_url"] as? String
		{
			return Owner(login: login, id: id, url: url, avatar_url: avatar_url)
		}
		return nil
	}
}