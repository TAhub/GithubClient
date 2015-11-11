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
	class func postRepository(name:String, description: String, completion: (String?)->())
	{
		do
		{
			let token = try OAuthClient.shared.accessToken()
			let urlString = "https://api.github.com/user/repos?access_token=\(token)"
			
			if let URL = NSURL(string: urlString)
			{
				let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
				
				let request = NSMutableURLRequest(URL: URL)
				request.HTTPMethod = "POST"
				
				//add http body
				request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["name":name, "description":description], options: NSJSONWritingOptions.PrettyPrinted)
				
				session.dataTaskWithRequest(request, completionHandler:
				{ (data, response, error) in
					if let error = error
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(error.description)
						}
					}
					else if let _ = data
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(nil)
						}
					}
				}).resume()
			}
		}
		catch _
		{
			//TODO: there was an error
		}
	}
	
	private class func fetchUserStarred(completion:(String?, [Repository]?)->())
	{
		do
		{
			let token = try OAuthClient.shared.accessToken()
			let urlString = "https://api.github.com/user/starred?access_token=\(token)"
			
			if let URL = NSURL(string: urlString)
			{
				let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
				
				let request = NSMutableURLRequest(URL: URL)
				request.HTTPMethod = "GET"
				
				session.dataTaskWithRequest(request, completionHandler:
				{ (data, response, error) in
					if let error = error
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(error.description, nil)
						}
					}
					else if let data = data, let repos = GithubJSONParser.reposFromNSData(data)
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(nil, repos)
						}
					}
					else
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion("ERROR: unable to parse JSON", nil)
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
	
	class func fetchUserInfo(completion:(String?, User?)->())
	{
		do
		{
			let token = try OAuthClient.shared.accessToken()
			let urlString = "https://api.github.com/user?access_token=\(token)"
			
			if let URL = NSURL(string: urlString)
			{
				let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
				
				let request = NSMutableURLRequest(URL: URL)
				request.HTTPMethod = "GET"
				
				session.dataTaskWithRequest(request, completionHandler:
				{ (data, response, error) in
					if let error = error
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(error.description, nil)
						}
					}
					else if let data = data, let user = GithubJSONParser.userFromNSData(data)
					{
						//now we have the user
						//but we still need to know how many things they have starred
						GithubService.fetchUserStarred()
						{ (error, starred) in
							//this is sent back to the main queue, so no need to send it again
							if let error = error
							{
								completion(error, nil)
							}
							else if let starred = starred
							{
								var userWithStars = user
								userWithStars.starred = starred.count
								completion(nil, userWithStars)
							}
						}
					}
					else
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion("ERROR: unable to parse JSON", nil)
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
	
	class func fetchMyRepositories(completion:(String?, [Repository]?)->())
	{
		do
		{
			let token = try OAuthClient.shared.accessToken()
			let urlString = "https://api.github.com/user/repos?access_token=\(token)"
			
			if let URL = NSURL(string: urlString)
			{
				let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
				
				let request = NSMutableURLRequest(URL: URL)
				request.HTTPMethod = "GET"
				
				session.dataTaskWithRequest(request, completionHandler:
				{ (data, response, error) in
					if let error = error
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(error.description, nil)
						}
					}
					else if let data = data, let repos = GithubJSONParser.reposFromNSData(data)
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(nil, repos)
						}
					}
					else
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion("ERROR: unable to parse JSON", nil)
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
	
	class func fetchRepositories(searchTerm:String, completion:(String?, [Repository]?)->())
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
				
				session.dataTaskWithRequest(request, completionHandler:
				{ (data, response, error) in
					if let error = error
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(error.description, nil)
						}
					}
					else if let data = data, let repos = GithubJSONParser.reposFromNSData(data)
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(nil, repos)
						}
					}
					else
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion("ERROR: unable to parse JSON", nil)
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
}