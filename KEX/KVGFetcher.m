//
//  KVGCache.m
//  KEX
//
//  Created by Daniel Schlaug on 3/11/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "KVGFetcher.h"
#import <CoreData/CoreData.h>

@interface KVGFetcher ()

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *documentQueue;

@end

@implementation KVGFetcher

- (UIManagedDocument *)document
{
    if (!_document) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"KVGFetcher";
        NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
        _document = [[UIManagedDocument alloc] initWithFileURL:url];
        BOOL fileExists = [fileManager fileExistsAtPath:[url path]];
        if (fileExists) {
            [_document openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    [self doDocumentQueue];
                } else {
                    NSLog(@"Couldn't open file at %@", _document.fileURL.path);
                }
            }];
        } else {
            [_document saveToURL:_document.fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   if (success) {
                       [self doDocumentQueue];
                   } else {
                       NSLog(@"Couldn't open file at %@", _document.fileURL.path);
                   }
               }];
        }
    }
    return _document;
}

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = self.document.managedObjectContext;
    }
    return _context;
}

- (void)doDocumentQueue
{
    if (self.document.documentState == UIDocumentStateNormal) {
        for (void (^documentAction)(void) in self.documentQueue) {
            documentAction();
        }
    }
}

- (KVGCharacter *)characterFor:(unichar)unicodeCharacter
{
    KVGCharacter *character = [self cachedCharacterFor:unicodeCharacter];
    if (!character) {
        NSString *characterFilename = [NSString stringWithFormat:@"%x", unicodeCharacter];
        NSString *prefix = [@"" stringByPaddingToLength:5-[characterFilename length] withString:@"0" startingAtIndex:0];
        characterFilename = [prefix stringByAppendingFormat:@"%@.svg", characterFilename];
        NSString *characterPath = [@"https://raw.github.com/KanjiVG/kanjivg/master/kanji/" stringByAppendingString:characterFilename];
        NSURL *characterURL = [NSURL URLWithString:characterPath];
        NSData *SVGData = [NSData dataWithContentsOfURL:characterURL];
        character = [KVGCharacter characterFromSVGData:SVGData inManagedObjectContext:self.context];
    }
    return character;
}

- (KVGCharacter *)cachedCharacterFor:(unichar)unicodeCharacter
{
    KVGCharacter *character = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KVGCharacter"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"character = %d", unicodeCharacter];
    NSError *executeFetchError = nil;
    character = [[self.context executeFetchRequest:request error:&executeFetchError] lastObject];
    
    if (executeFetchError) {
        NSLog(@"[%@, %@] error looking up character with id: %i with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), unicodeCharacter, [executeFetchError localizedDescription]);
    }
    
    return character;
}

@end
