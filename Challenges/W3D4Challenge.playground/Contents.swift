//: Playground - noun: a place where people can play

import UIKit

//doubles letters I guess
func letterDoubler(string:String)->String
{
	var doubledString = ""
	for i in string.characters.startIndex..<string.characters.endIndex
	{
		doubledString.append(string.characters[i])
		doubledString.append(string.characters[i])
	}
	return doubledString
}

//examples
letterDoubler("Hello")
letterDoubler("Hello world!")
letterDoubler("")