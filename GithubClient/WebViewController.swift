//
//  WebViewController.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/12/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var webView: UIWebView!
	{
		didSet
		{
			webView.delegate = self
		}
	}
	var urlString:String!

	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(true)
		
		if let URL = NSURL(string: urlString)
		{
			let request = NSURLRequest(URL: URL)
			webView.loadRequest(request)
		}
		else
		{
			die()
		}
	}
	
	private func die()
	{
		navigationController!.popViewControllerAnimated(true)
	}
	
	//MARK: web view delegate
	func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
	{
		die()
	}
}
