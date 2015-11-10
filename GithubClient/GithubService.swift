//
//  GithubService.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/9/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class GithubService
{
	class func fetchRepositories(searchTerm:String, completion:(String?, [String]?)->())
	{
		do
		{
			let token = try OAuthClient.shared.accessToken()
			let urlString = "https://api.github.com/search/repositories?q=\(searchTerm)&access_token=\(token)"
			
			if let URL = NSURL(string: urlString)
			{
				let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
				
				let request = NSMutableURLRequest(URL: URL)
				request.HTTPMethod = "GET"
				
//				session.dataTaskWithURL(URL, completionHandler:
				session.dataTaskWithRequest(request, completionHandler:
				{ (data, response, error) in
					if let error = error
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(error.description, nil)
						}
					}
					else if let data = data
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(nil, reposFromJSON(data)!)
						}
					}
				}).resume()
			}
		}
		catch let error
		{
			completion("\(error)", nil)
		}
	}
	
	//MARK: JSON
	class func reposFromJSON(json: NSData) -> [String]?
	{
		do
		{
			if let rootObject = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject]
			{
				if let items = rootObject["items"] as? [[String: AnyObject]]
				{
					var repos = [String]()
					for item in items
					{
						if let name = item["name"] as? String
						{
							repos.append(name)
						}
					}
					return repos
				}
			}
		}
		catch
		{
			//there was an exception
		}
		return nil
	}
}