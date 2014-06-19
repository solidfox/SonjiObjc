//
//  DSFullCharacter.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/9/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation

@objc class CharacterMetadata {
    
    let _kvg: KVGCharacter
    let _wwwjdic: WWWJDICEntry
    
    var character: Character
    var strokes: KVGStroke[] {
    
    get {
        var strokes: KVGStroke[] = []
        let optionalKVGStrokes = _kvg.strokes() as KVGStroke[]?
        
        if let KVGStrokes = optionalKVGStrokes {
            strokes = KVGStrokes
        }
        
        return strokes
    }
    
    }
    
    var kunReadings: String[] {
    
    get {
        return _wwwjdic.kunReadings
    }
    
    }
    
    var translations: String[] {
    
    get {
        return _wwwjdic.translations
    }
    
    }
    
    init(kvg: KVGCharacter!, wwwjdic: WWWJDICEntry!) {
        assert(kvg, "kvg cannot be nil")
        assert(wwwjdic, "wwwjdic cannot be nil")
        _kvg = kvg
        _wwwjdic = wwwjdic
        character = wwwjdic.character
    }
    
}