//: Playground - noun: a place where people can play

import UIKit

//is the number within 2 of a multiple of 10?
func nearTen(num:UInt) -> Bool
{
	return (num % 10) <= 2 || (num % 10) >= 8
}


//examples
for i:UInt in 0...20
{
	print("\(i) is\(nearTen(i) ? "" : " not") within 2 of a multiple of 10!")
}