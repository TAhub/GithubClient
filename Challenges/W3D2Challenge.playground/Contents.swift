//: Playground - noun: a place where people can play

import UIKit

//gets the highest and the lowest of any array of comparable things
func highAndLow<T where T:Comparable>(values:[T]) -> (high:T, low:T)?
{
	var hAL:(T, T)?
	for val in values
	{
		if hAL == nil
		{
			hAL = (val, val)
		}
		else
		{
			hAL = (max(hAL!.0, val), min(hAL!.1, val))
		}
	}
	return hAL
}


//example
let hAL = highAndLow([1, 2, 3, 4, 5])!
hAL.high
hAL.low

let hAL2 = highAndLow(["a", "ccc", "bb"])!
hAL2.high
hAL2.low