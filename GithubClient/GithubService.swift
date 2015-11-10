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
	class func postRepository()
	{
		
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
					else if let data = data
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(nil, GithubJSONParser.reposFromNSData(data)!)
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