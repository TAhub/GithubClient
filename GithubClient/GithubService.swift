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
//	var user:User!
//	static let sharedService = GithubService()
	
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
				request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["name":name, "description":description], options: NSJSONWritingOptions())
				
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