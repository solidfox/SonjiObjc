//
//  CharacterTest.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/18/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CharacterTestDelegate {
    @optional func didCompleteRadical()
}

@objc protocol Stroke {
    var path: UIBezierPath {get}
}

extension KVGStroke: Stroke {}

class CharacterTest: NSObject {
    
    let _metadata: CharacterMetadata
    var score: Double = 0
    var desiredStrokeIndex: Int = 0
    var userStrokes: UserStroke[] = []
    var desiredStrokes: Stroke[] {
    get {
        return _metadata.strokes
    }
    }

    init(characterMetadata: CharacterMetadata) {
        _metadata = characterMetadata
    }
    
    func userStartedStrokeAtPoint(point:CGPoint) {
        userStrokes += UserStroke(startingPoint: point)
        // TODO Calculate and indicate score
    }
    
    func userMovedToPoint(point:CGPoint) {
        let userStroke = userStrokes[desiredStrokeIndex]
        userStroke.addPoint(point)
        // TODO Calculate and indicate score
    }
    
    func userCompletedStrokeAtPoint(point:CGPoint) {
        
    }
    
    // Character meaning
    
    // Character reading
    
    class UserStroke: Stroke {
        var path: UIBezierPath = UIBezierPath()
        var nPoints = 1
        
        init(startingPoint:CGPoint) {
            path.moveToPoint(startingPoint)
        }
        
        func addPoint(point:CGPoint) {
            path.addLineToPoint(point)
            ++nPoints
        }
    }
}
