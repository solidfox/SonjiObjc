//
//  SwiftGoodies.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/10/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation

/* Simple regex */
/* Thanks to http://vperi.com/2014/06/08/regular-expressions-in-switch-statements/ */
/* enables
    switch "some" {
    case ~/"\\w{4}":
        //Totally matches!!!
    }
*/
func ~=(pattern: NSRegularExpression, str: NSString) -> Bool {
    return pattern.numberOfMatchesInString(str, options: nil, range: NSRange(location: 0,  length: str.length)) > 0
}

func ~=(str: NSString, pattern: NSRegularExpression) -> Bool {
    return pattern.numberOfMatchesInString(str, options: nil, range: NSRange(location: 0,  length: str.length)) > 0
}

operator prefix ~/ {}

@prefix func ~/(pattern: String) -> NSRegularExpression {
    return NSRegularExpression(pattern: pattern, options: nil, error: nil)
}

/* Substrings and characters */
extension String {
    subscript(index: Int) -> Character {
        get {
            assert(index > -1, "Index out of bounds")
            var i = 0
            
            for char in self {
                if i == index {
                    return char
                }
                ++i
            }
            assert(false, "Index out of bounds")
            return "0"
        }
    }
    
    subscript(range: Range<Int>) -> String {
        get {
            assert(range.startIndex > -1, "Index out of bounds")
            var string = ""
            var i = 0
            for char in self {
                if i >= range.startIndex && i <= range.endIndex {
                    string += char
                }
                ++i
            }
            return string
        }
    }
    
}