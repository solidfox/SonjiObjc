//
//  KVGRepository.h
//  Methods for loading characters from the KanjiVG source repository.
//
//  Created by Daniel Schlaug on 3/11/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KVGCharacter.h"

@interface KVGRepository : NSObject

+ (NSString *)repositoryURLFor:(unichar)unicodeCharacter;

/**
 *  Use this to download the Kanji VG XML data of a given character from the online repository. Will block until done.
 *
 *  @param unicodeCharacter The unicode character for which to download the XML data.
 *
 *  @return Returns an NSData object containing the XML Data for the given character downloaded repository.
 */
+ (NSData *)downloadCharacterDataFor:(unichar)unicodeCharacter;

/**
 *  Loads KVGCharacter objects from the local cache or fetches them from the online repository to the local cache and to memory.
 *
 *  @param character         The unicode character for which to load the KVGCharacter object.
 *  @param completionHandler The block to execute upon completion. Will be executed on the main queue. //TODO is this wise?
 */
- (void)loadCharacterDataFor:(unichar)character completionHandler:(void (^)(BOOL success))completionHandler;

/**
 *  Use this to get the KVGCharacter object for characters that have already been loaded.
 *
 *  @param character The unicode character of the desired KVGCharacter object.
 *
 *  @return Returns the KVGCharacter object for the given character provided that it has already been loaded into memory. Otherwise returns nil.
 */
- (KVGCharacter *)KVGCharacterFor:(unichar)character;

/**
 *  Use this to initialize a new cached KVGRepository with its local cache file in the URL of your choice.
 *
 *  @param localCacheURL The URL at which to create the local cache file.
 *
 *  @return the initialized KVGRepository.
 */
- (id)initWithLocalCacheURL:(NSURL *)localCacheURL;

/**
 *  Use this to initialize a new cached KVGRepository with its local cache file in the default URL.
 *
 *  @return the initialized KVGRepository.
 */
- (id)initWithDefaultLocalCacheURL;

@end
