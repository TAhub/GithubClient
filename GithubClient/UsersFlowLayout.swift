//
//  UsersFlowLayout.swift
//  GithubClient
//
//  Created by Theodore Abshire on 11/12/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class UsersFlowLayout: UICollectionViewFlowLayout
{
	override init()
	{
		super.init()
		itemSize = CGSize(width: 50, height: 50)
		sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
}
