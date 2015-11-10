//
//  OAuthClient.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/9/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

let kAccessTokenKey = "kAccessTokenKey"
let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^&]+)"

enum OAuthErrors:ErrorType
{
	case ExtractingCode(String)
	case ExtractingTokenFromString(String)
	case MissingAccessToken(String)
}

class OAuthClient
{
	//my github oauth client console
	//https://github.com/settings/applications/263560
	var githubClientId = "a348c30dbcc2a0fe0dd1"
	var githubClientSecret = "4d1f7e60e306a1cdc64430fa5e11e833ce4e288c"
	
	static let shared = OAuthClient()
	
	func oauthRequest(parameters: [String : String])
	{
		let parameterString:String = parameters.reduce("") { "\($0)&\($1.0)=\($1.1)" }
		if let requestURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(self.githubClientId)\(parameterString)")
		{
			UIApplication.sharedApplication().openURL(requestURL)
		}
	}
	
	func tokenRequestWithCallback(url: NSURL, completion: (Bool)->())
	{
		do
		{
			let code = try self.codeFromCallback(url)
			let finalString = "\(kOAuthBaseURLString)access_token?client_id=\(self.githubClientId)&client_secret=\(self.githubClientSecret)&code=\(code)"
			
			if let finalURL = NSURL(string: finalString)
			{
				let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
				let session = NSURLSession(configuration: configuration)
				
				session.dataTaskWithURL(finalURL, completionHandler: { (data, response, error) in
					if let _ = error
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							completion(false)
						}
					}
					else if let data = data, tokenString = self.dataToString(data)
					{
						do
						{
							let token = try self.accessTokenFromString(tokenString)!
							
							NSOperationQueue.mainQueue().addOperationWithBlock()
							{
								completion(self.saveToken(token))
							}
						}
						catch _
						{
							NSOperationQueue.mainQueue().addOperationWithBlock()
							{
								completion(false)
							}
						}
					}
				}).resume()
				
				
			}
		}
		catch _
		{
			completion(false)
		}
	}
	
	private func saveToken(token:String) -> Bool
	{
		//defaults-based
//		NSUserDefaults.standardUserDefaults().setObject(token, forKey: kAccessTokenKey)
//		return NSUserDefaults.standardUserDefaults().synchronize()
		
		//keychain-based
		KeychainService.save(token)
		return KeychainService.load() != nil
	}
	
	func accessToken() throws -> String
	{
		//defaults-based
//		guard let token = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else
		
		//keychain-based
		guard let token = KeychainService.load() as? String else
		{
			throw OAuthErrors.MissingAccessToken("ERROR: no access token saved.")
		}
		return token
	}
	
	
	//MARK: helper functions
	private func codeFromCallback(url:NSURL) throws -> String
	{
		guard let code = url.absoluteString.componentsSeparatedByString("=").last else
		{
			throw OAuthErrors.ExtractingCode("ERROR: unable to extract code from URL.")
		}
		return code
	}
		
	private func accessTokenFromString(string: String) throws -> String?
	{
		do
		{
			let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
			let matches = regex.matchesInString(string, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, string.characters.count))
			
			if matches.count > 0
			{
				//get first match
				let matchRange = matches[0].rangeAtIndex(1)
				return (string as NSString).substringWithRange(matchRange)
			}
		}
		catch _
		{
			throw OAuthErrors.ExtractingTokenFromString("ERROR: unable to extract token from string.")
		}
		
		return nil
	}
	
	private func dataToString(data:NSData)->String?
	{
		let buffer = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
		return String(bytes: buffer, encoding: NSASCIIStringEncoding)
	}
}