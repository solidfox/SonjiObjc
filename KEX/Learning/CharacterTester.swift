//
//  CharacterTester.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/18/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation

class CharacterTester: NSObject, CharacterMetadataRepositoryDelegate {
    
    var _charactersToTest: Character[] = ["土","日","囗","甲","上","木","大","天","下","雨"]
    var _loadingCharacters: Character[] = []
    var _metadataForCharacter: Dictionary<Character, CharacterMetadata> = [:]
    let _metadataRepo: CharacterMetadataRepository! = nil
    var _readyHandler: (Void) -> Void
    
    init(readyHandler: (Void) -> Void = {}) {
        _readyHandler = readyHandler
        super.init()
        _metadataRepo = CharacterMetadataRepository(delegate:self)
        _loadingCharacters = _charactersToTest
        for character in _charactersToTest {
            _metadataRepo.loadCharacterMetadataFor(character)
        }
    }
    
    var _currentCharacter: Character {
    get {
        return _charactersToTest[0]
    }
    }
    
    var currentTest: CharacterTest {
    get {
        let metadata = _metadataForCharacter[_currentCharacter]
        if !metadata {
            assert(false, "There was no metadata for current character.")
        }
        return CharacterTest(characterMetadata: metadata!)
    }
    }
    
    
    func nextTest() -> CharacterTest {
        _charactersToTest += _charactersToTest.removeAtIndex(0)
        return currentTest
    }

    func _characterMetadataRepository(repository: CharacterMetadataRepository, didFinishLoadingMetadata metadata: CharacterMetadata) {
        let character = metadata.character
        _loadingCharacters.filter {$0 != character}
        _metadataForCharacter[character] = metadata
        if _loadingCharacters.count == 0 {
            let readyHandler = _readyHandler
            _readyHandler = {}
            readyHandler()
        }
    }
    func _characterMetadataRepository(repository: CharacterMetadataRepository, didFailLoadingMetadataForCharacter character: String, withError error: NSError!) {
        println(error)
        _metadataRepo.loadCharacterMetadataFor(character[0])
    }
}
