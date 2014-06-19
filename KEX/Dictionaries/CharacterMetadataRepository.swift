//
//  CharacterRepository.swift
//  
//
//  Created by Daniel Schlaug on 6/15/14.
//
//
import Foundation

protocol CharacterMetadataRepositoryDelegate {
    func characterMetadataRepository(repository: CharacterMetadataRepository, didFinishLoadingMetadata metadata: CharacterMetadata)
    func characterMetadataRepository(repository: CharacterMetadataRepository, didFailLoadingMetadataForCharacter character: String, withError error: NSError!)
}

extension KVGCharacter {
    class func filenameOfCharacter(character:Character) -> String {
        let characterString = String(character)
        let scalars = characterString.unicodeScalars
        let scalar = scalars[scalars.startIndex].value
        let intScalar = Int(scalar)
        let characterUnicodeScalarString = NSString(format:"%x", intScalar)
        let nZeroes = 5 - characterUnicodeScalarString.length
        let prefix = "".stringByPaddingToLength(nZeroes, withString: "0", startingAtIndex: 0)
        let KVGFilename = prefix + characterUnicodeScalarString + ".svg";
        return KVGFilename
    }
}

class CharacterMetadataRepository: NSObject {
    
    var _URLSession: NSURLSession
    var _loadingCharacters: Dictionary<String, (KVGCharacter?, WWWJDICEntry?)> = [:]
    
    let delegate: CharacterMetadataRepositoryDelegate
    let delegateQueue: NSOperationQueue
    
    init(delegate: CharacterMetadataRepositoryDelegate, delegateQueue:NSOperationQueue = NSOperationQueue.currentQueue()) {
        self.delegate = delegate
        self.delegateQueue = delegateQueue
        _URLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    func loadCharacterMetadataFor(character: Character) {
        if !_loadingCharacters[String(character)] {
            
            _loadingCharacters[String(character)] = (nil, nil)
            
            let urlEscapedCharacter = String(character).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let KVGFilename = KVGCharacter.filenameOfCharacter(character)
            let kanjiVGURL = NSURL.URLWithString("https://raw.github.com/KanjiVG/kanjivg/master/kanji/\(KVGFilename)")
            let wwwjdicURL = NSURL.URLWithString("http://www.csse.monash.edu.au/~jwb/cgi-bin/wwwjdic.cgi?1ZMJ\(urlEscapedCharacter)")

            let kanjiVGDownloadTask = _URLSession.downloadTaskWithURL(kanjiVGURL) {
                (location, response, error) in
                
                if error {
                    self.delegateQueue.addOperationWithBlock {
                        self.delegate.characterMetadataRepository(self, didFailLoadingMetadataForCharacter: String(character), withError: error)
                    }
                    return
                }
                
                var (_, optionalWWWJDICEntry) = self._loadingCharacters.removeValueForKey(String(character))!
                
                var error: NSError?
                var data = NSData.dataWithContentsOfFile(location.path, options: NSDataReadingOptions.MappedRead, error: &error)
                if error {
                    fatalError("CharacterMetadataRepository failed to load contents of just downloaded file.")
                }
                
                var optionalKVGEntry = KVGCharacter.characterFromSVGData(data) as? KVGCharacter
                
                if optionalWWWJDICEntry && optionalKVGEntry {
                    let metadata = CharacterMetadata(kvg: optionalKVGEntry!, wwwjdic: optionalWWWJDICEntry!)
                    self.delegateQueue.addOperationWithBlock {
                        self.delegate.characterMetadataRepository(self, didFinishLoadingMetadata:metadata)
                    }
                } else if optionalKVGEntry {
                    self._loadingCharacters[String(character)] = (optionalKVGEntry, nil)
                } else {
                    //TODO Return some sensible error
                    self.delegate.characterMetadataRepository(self, didFailLoadingMetadataForCharacter: String(character), withError: nil)
                }
            }
            let wwwjdicDownloadTask = _URLSession.downloadTaskWithURL(wwwjdicURL) {
                (location, response, error) in
                var (optionalKVGEntry, _) = self._loadingCharacters.removeValueForKey(String(character))!
                
                var error: NSError?
                var data = NSData.dataWithContentsOfFile(location.path, options: NSDataReadingOptions.MappedRead, error: &error)
                if error {
                    fatalError("CharacterMetadataRepository failed to load contents of just downloaded file.")
                }
                
                var optionalWWWJDICEntry = WWWJDICEntry.entryFromRawWWWJDICResponse(NSString(data: data, encoding: NSUTF8StringEncoding))
                
                if optionalWWWJDICEntry && optionalKVGEntry {
                    let metadata = CharacterMetadata(kvg: optionalKVGEntry!, wwwjdic: optionalWWWJDICEntry!)
                    self.delegateQueue.addOperationWithBlock {
                        self.delegate.characterMetadataRepository(self, didFinishLoadingMetadata:metadata);
                    }
                } else if optionalWWWJDICEntry {
                    self._loadingCharacters[String(character)] = (nil, optionalWWWJDICEntry)
                } else {
                    //TODO Return some sensible error
                    self.delegate.characterMetadataRepository(self, didFailLoadingMetadataForCharacter: String(character), withError: nil)
                }
            }
            
            kanjiVGDownloadTask.resume()
            wwwjdicDownloadTask.resume()
        }
    }
    
}
