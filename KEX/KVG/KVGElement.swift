//
//  KVGElement.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/25/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation
import DanielsKit

enum KVGRadical: String {
    case General = "general"
    case Nelson = "nelson"
    case Tradit = "tradit"
}

enum KVGPosition: String {
    case Left = "left"
    case Right = "right"
    case Top = "top"
    case Bottom = "bottom"
    case Nyo = "nyo"
    case Tare = "tare"
    case Kamae = "kamae"
    case Kamae1 = "kamae1"
    case Kamae2 = "kamae2"
}

class KVGElement: NSObject {
    let mostSimilarUnicode: Character?
    let semanticUnicode: Character?
    let position: KVGPosition?
    let radical: KVGRadical?
    let variant: Bool
    let partial: Bool
    let number: Integer?
    let childElements: KVGElement[]
    let parentElement: KVGElement?
    let rootStrokes: KVGStroke[]
    
    var strokes: KVGStroke[] {
        var strokes = rootStrokes
        for childElement in childElements {
            strokes += childElement.strokes
        }
            
        strokes = sort(strokes) {$0.strokeOrder > $1.strokeOrder}
        
        return strokes
    }

    init(RXML elementNode: RXMLElement) {
        if let elementAttribute = elementNode.attribute("element"){
            mostSimilarUnicode = elementAttribute[0]
        }
        if let originalAttribute = elementNode.attribute("original") {
            semanticUnicode = originalAttribute[0]
        }
        if let positionAttribute = elementNode.attribute("position") {
            position = KVGPosition.fromRaw(positionAttribute)
        }
        if let radicalAttribute = elementNode.attribute("radical") {
            radical = KVGRadical.fromRaw(radicalAttribute)
        }
        if let variantAttribute = elementNode.attribute("variant") {
            variant = variantAttribute == "true"
        } else {variant = false}
        if let partialAttribute = elementNode.attribute("partial") {
            partial = partialAttribute == "true"
        } else {partial = false}
        if let numberAttribute = elementNode.attribute("number") {
            number = numberAttribute.toInt()
        }
        
        var childElements: KVGElement[] = []
        var rootStrokes: KVGStroke[] = []
        
        elementNode.iterate("*") {
            (elementChildNode: RXMLElement!) in
            if elementChildNode.tag == "g" {
                childElements += KVGElement(RXML: elementChildNode)
            } else if elementChildNode.tag == "path" {
                rootStrokes += KVGStroke(RXML: elementChildNode)
            }
        }
        
        self.childElements = childElements
        self.rootStrokes = rootStrokes
    }
    
}
