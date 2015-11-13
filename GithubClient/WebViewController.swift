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

	@IBOutlet weak var urlBacker: UIView!
	{
		didSet
		{
			urlBacker.winterBorder()
		}
	}
	
	@IBOutlet weak var backButton: UIButton!
	{
		didSet
		{
			backButton.winterBorder()
		}
	}
	
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	
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
	
	@IBAction private func die()
	{
		navigationController!.popViewControllerAnimated(true)
	}
	
	//MARK: web view delegate
	func webViewDidStartLoad(webView: UIWebView)
	{
		spinner.startAnimating()
	}
	func webViewDidFinishLoad(webView: UIWebView)
	{
		spinner.stopAnimating()
	}
	func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
	{
		spinner.stopAnimating()
		die()
	}
}
