//
//  KVGEntry.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/26/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation
import DanielsKit

class KVGEntry: NSObject {

    let character: Character
    let element: KVGElement
    var strokes: KVGStroke[] {
        return element.strokes
    }
    
    init(SVGData:NSData) {
        let optRootNode = RXMLElement.elementFromXMLData(SVGData) as? RXMLElement
        if let rootNode = optRootNode {
            var intermediateElement: KVGElement? = nil
            rootNode.iterate("g") {(element: RXMLElement!) in
                if element.attribute("id").hasPrefix("kvg:StrokePaths") {
                    let strokePathsNode = element
                    let characterGroup = strokePathsNode.child("g")
                    intermediateElement = KVGElement(RXML:characterGroup)
                }
            }
            self.element = intermediateElement!
            self.character = element.mostSimilarUnicode!
        } else {fatalError("Tried to initiate a KVGEntry from non-XML data.")}
    }
    
    func strokeWithStrokeCount(count:Int) -> KVGStroke {
        return strokes[count - 1]
    }
    
    func _isValidKanjiVGFile(root: RXMLElement) -> Bool {
        var isValid = false
        
        if root.isValid && root.tag == "svg" {
            let characterGroup = root.children("g")[0].child("g")
            let idAttr = characterGroup.attribute("id")!
            isValid = idAttr ~= ~/"^kvg:([a-f0-9]{5})$"
        }
        
        return isValid
    }
}
