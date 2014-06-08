//
//  KVGRepository.m
//
//  Created by Daniel Schlaug on 3/11/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "KVGRepository.h"
#import "KVGRawCharacter.h"

@interface KVGRepository ()

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSMutableDictionary *loadedCharacters;

@end


@implementation KVGRepository

+ (NSString *)repositoryURLFor:(unichar)unicodeCharacter
{
    NSString *characterFilename = [NSString stringWithFormat:@"%x", unicodeCharacter];
    NSAssert([characterFilename length] <= 5, @"Generated kanji filename was longer than expected (5 characters): %@", characterFilename);
    NSUInteger prefixZeroes = 5-[characterFilename length];
    NSString *prefix = [@"" stringByPaddingToLength:prefixZeroes withString:@"0" startingAtIndex:0];
    characterFilename = [prefix stringByAppendingFormat:@"%@.svg", characterFilename];
    return [@"https://raw.github.com/KanjiVG/kanjivg/master/kanji/" stringByAppendingString:characterFilename];
}

+ (NSData *)downloadCharacterDataFor:(unichar)unicodeCharacter
{
    NSURL *characterURL = [NSURL URLWithString:[KVGRepository repositoryURLFor:unicodeCharacter]];
    NSData *SVGData = [NSData dataWithContentsOfURL:characterURL];
    return SVGData;
}

- (id)initWithLocalCacheURL:(NSURL *)localCacheURL
{
    self = [self init];
    
    if (self) {
        self.document = [[UIManagedDocument alloc] initWithFileURL:localCacheURL];
        [self openDocument];
    }
    
    return self;
}

- (id)initWithDefaultLocalCacheURL
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *cacheDBName = @"KVGCache";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:cacheDBName];
    return [self initWithLocalCacheURL:url];
}

- (void)loadCharacterDataFor:(unichar)character completionHandler:(void (^)(BOOL success))completionHandler
{
    
    [self.document performAsynchronousFileAccessUsingBlock:^{
        KVGCharacter *kvgCharacter = nil;
        
        NSManagedObjectContext *context = self.document.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KVGRawCharacter"];
        
        NSString *predicateString = [NSString stringWithFormat:@"unicodeCharacter = \"%C\"", character];
        
        request.predicate = [NSPredicate predicateWithFormat:predicateString];
        
        NSError *error;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if (!results) {
            NSLog(@"%@", [error description]);
        }
        
        if (!results || [results count] == 0) {
            NSData *xmlCharacterData = [KVGRepository downloadCharacterDataFor:character];
            
            [self insertKVGRawCharacterFor:character withData:xmlCharacterData];
            
            kvgCharacter = [KVGCharacter characterFromSVGData:xmlCharacterData];
        } else {
            NSAssert([results count] == 1, @"Fetched %lui results from database for character %C. Character property should be unique!", [results count], character);
            KVGRawCharacter *rawCharacter = [results objectAtIndex:0];
            kvgCharacter = [KVGCharacter characterFromSVGData:rawCharacter.xmlData];
        }
        
        if (kvgCharacter) {
            self.loadedCharacters[[NSString stringWithFormat:@"%C", character]] = kvgCharacter;
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(YES);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(NO);
            });
        }
    }];
}

/**
 MUST BE RUN IN performAsynchronousFileAccessUsingBlock: block. (Like it is in loadCharacterDataFor:)
 */
- (KVGRawCharacter *)insertKVGRawCharacterFor:(unichar)character withData:(NSData *)XMLData
{
    KVGRawCharacter *rawCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"KVGRawCharacter" inManagedObjectContext:self.document.managedObjectContext];
    rawCharacter.unicodeCharacter = [NSString stringWithFormat:@"%C", character];
    rawCharacter.xmlData = XMLData;
    [self saveDocument];
    return rawCharacter;
}

- (KVGCharacter *)KVGCharacterFor:(unichar)character
{
    
    KVGCharacter *KVGCharacter = [self.loadedCharacters objectForKey:[NSString stringWithFormat:@"%C", character]];
    
    if (!KVGCharacter) {
        NSLog(@"Character %u was not loaded when requested. This is probably not good at all!", character);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [self loadCharacterDataFor:character completionHandler:^(BOOL success) {
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
        
        KVGCharacter = [self.loadedCharacters objectForKey:[NSString stringWithFormat:@"%C", character]];
    }
    
    return KVGCharacter;
}

- (BOOL)characterIsReady:(unichar)character
{
    return [self.loadedCharacters objectForKey:[NSString stringWithFormat:@"%C", character]] != nil;
}


#pragma Document funtions

- (void)openDocument
{
    NSURL *localCacheURL = self.document.fileURL;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[localCacheURL path]];
    if (!fileExists) {
        [self.document saveToURL:localCacheURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if (success) {
                [self documentReady];
            } else {
                [self documentFailedToOpen];
            }
        }];
    } else {
        [self.document openWithCompletionHandler:^(BOOL success){
            if (success) {
                [self documentReady];
            } else {
                [self documentFailedToOpen];
            }
        }];
    }
}

- (void)documentReady
{
    NSAssert(self.document.documentState == UIDocumentStateNormal, @"Document seems to have failed to open/create!");
}

- (void)documentFailedToOpen
{
    
}

-(void)saveDocument
{
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:^(BOOL success) {    }];
}

- (NSMutableDictionary *)loadedCharacters
{
    if (!_loadedCharacters) {
        _loadedCharacters = [[NSMutableDictionary alloc] init];
    }
    
    return _loadedCharacters;
}

@end
