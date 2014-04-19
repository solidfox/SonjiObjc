//
//  KVGRepository.h
//  Methods for loading characters from the KanjiVG source repository.
//
//  Created by Daniel Schlaug on 3/11/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVGRepository : NSObject

+ (NSString *)repositoryURLFor:(unichar)unicodeCharacter;

/**
 Gets a KVGCharacter object for the given character from the cache or, if the cache does not have the character, from the github repository.
 */
+ (NSData *)characterDataFor:(unichar)unicodeCharacter;

/**
 Asynchronously caches the characters in the given string from the KanjiVG git hub repository for fast access through getKVGCharacterFor. Will skip those already cached. getKVGCharacterFor will still work for uncached characters but may block the main thread while trying to download the character.
 */
//- (NSArray *)cacheCharacters:(NSString *)characterString;

@end
