//
//  KVGStroke.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/25/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation
import CoreGraphics
import DanielsKit

class KVGStroke: NSObject {
    
    let path: UIBezierPath
    let type: Character
    let strokeOrder: Int = 0
    
    init(RXML pathElement: RXMLElement) {
        let idAttribute = pathElement.attribute("id")
        let strokeOrderRegExp = ~/".*-s([1-9][0-9]?)(-.*|$)"
        let strokeOrderString: NSString = strokeOrderRegExp.stringByReplacingMatchesInString(idAttribute, options: nil, range: idAttribute.fullRange, withTemplate: "$1")
        let strokeOrder = strokeOrderString.integerValue
        self.strokeOrder = strokeOrder
        assert(strokeOrder != 0, "Could not parse stroke order.")
        
        
        let aCGPath: CGPath = PocketSVG.pathFromDAttribute(pathElement.attribute("d")).takeRetainedValue() //WARNING not sure that this should be retained
        self.path = UIBezierPath(CGPath: aCGPath)
        
        self.type = pathElement.attribute("type")[0]
    }
}