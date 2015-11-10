//
//  KeychainService.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/10/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import Foundation
import Security

// Identifiers
let userAccount = "github"
let accessGroup = "MyService"

// Arguments for the keychain queries
let kSecClassValue = kSecClass as NSString
let kSecAttrAccountValue = kSecAttrAccount as NSString
let kSecValueDataValue = kSecValueData as NSString
let kSecClassGenericPasswordValue = kSecClassInternetPassword as NSString
let kSecAttrServiceValue = kSecAttrService as NSString
let kSecMatchLimitValue = kSecMatchLimit as NSString
let kSecReturnDataValue = kSecReturnData as NSString
let kSecMatchLimitOneValue = kSecMatchLimitOne as NSString

class KeychainService
{
	//this code is all just based on the keychain sample
	
	class func save(data:NSString)
	{
		let dataFromString = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
		let keychainQuery:NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrAccountValue, kSecValueDataValue])
		SecItemDelete(keychainQuery)
		SecItemAdd(keychainQuery, nil)
	}
	
	class func load() -> NSString?
	{
		let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
		
		var dataTypeRef:AnyObject?
		SecItemCopyMatching(keychainQuery, &dataTypeRef)
		
		var contentsOfKeychain:NSString?
		if let retainedData = dataTypeRef as? NSData
		{
			contentsOfKeychain = NSString(data: retainedData, encoding: NSUTF8StringEncoding)
		}
		
		return contentsOfKeychain
	}
}