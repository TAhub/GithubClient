//: Playground - noun: a place where people can play

import UIKit

//ok I admit I wasn't 100% sure what this challenge was supposed to be
//it said the middle, length 3, so I assume you meant the middle three elements
enum MiddleElementsError : ErrorType
{
	case NotOdd(String)
	case TooSmall(String)
}

func middleElements<T>(array:[T]) throws -> [T]
{
	guard array.count % 2 == 1 else
	{
		throw MiddleElementsError.NotOdd("ERROR: \(array.count) is not an odd number!")
	}
	guard array.count >= 3 else
	{
		throw MiddleElementsError.TooSmall("ERROR: \(array.count) is not 3 or more!")
	}
	
	let middle = (array.count - 1) / 2
	return [array[middle - 1], array[middle], array[middle + 1]]
}

//test
do
{
	print(try middleElements(["bad", "good", "good", "good", "bad"]))
}
catch let error
{
	print(error)
}

do
{
	print(try middleElements(["good", "good", "good"]))
}
catch let error
{
	print(error)
}

do
{
	print(try middleElements(["invalid"]))
}
catch let error
{
	print(error)
}

do
{
	print(try middleElements(["invalid", "invalid", "invalid", "invalid"]))
}
catch let error
{
	print(error)
}