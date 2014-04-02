//
//  KVGCharacter+Creation.m
//  KEX
//
//  Created by Daniel Schlaug on 3/17/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "KVGCharacter+Creation.h"

@implementation KVGCharacter (Creation)

- (NSArray *)strokes
{
    return [self.element strokes];
}

#pragma mark Initialization

+ (KVGCharacter *)characterFromSVGFile:(NSString *)filename
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    RXMLElement *rootNode = [RXMLElement elementFromXMLFile:[NSString stringWithFormat:@"%@.svg", filename]];
    
    KVGCharacter *character = [self characterFromRXMLElement:rootNode
                                      inManagedObjectContext:context];
    
    return character;
}

+ (KVGCharacter *)characterFromSVGData:(NSData *)data
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    RXMLElement *rootNode = [RXMLElement elementFromXMLData:data];
    
    KVGCharacter *character = [self characterFromRXMLElement:rootNode
                                      inManagedObjectContext:context];
    
    return character;
}

+ (KVGCharacter *)characterFromRXMLElement:(RXMLElement *)rootNode
                    inManagedObjectContext:(NSManagedObjectContext *)context
{
    KVGCharacter *character = nil;
    
    if ([self isValidKanjiVGFile:rootNode]){
        
        __block RXMLElement *strokePathsNode = nil;
        [rootNode iterate:@"g" usingBlock:^(RXMLElement *group) {
            if ([[group attribute:@"id"] hasPrefix:@"kvg:StrokePaths"]) {
                strokePathsNode = group;
            }
        }];
        
        RXMLElement *characterGroup = [strokePathsNode child:@"g"];
        
        NSString *unicodeCharacter = [characterGroup attribute:@"element"];
        
        character = [KVGCharacter characterFromUnicode:unicodeCharacter inManagedObjectContect:context];
        
        character.element = [KVGElement elementFromRXML:characterGroup inManagedObjectContext:context];
    }
    
    return character;
}

+ (KVGCharacter *)characterFromUnicode:(NSString *)unicodeCharacter
                inManagedObjectContect:(NSManagedObjectContext *)context {
    KVGCharacter *character = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KVGCharacter"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"character = %d", unicodeCharacter];
    NSError *executeFetchError = nil;
    character = [[context executeFetchRequest:request error:&executeFetchError] lastObject];
    
    if (executeFetchError) {
        NSLog(@"[%@, %@] error looking up character with id: %@ with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), unicodeCharacter, [executeFetchError localizedDescription]);
    } else if (!character) {
        character = [NSEntityDescription insertNewObjectForEntityForName:@"KVGCharacter"
                                                  inManagedObjectContext:context];
        character.character = unicodeCharacter;
    }
    
    return character;
}


#pragma mark - Private methods

+ (bool) isValidKanjiVGFile: (RXMLElement *) root
{
    NSRegularExpression *characterCodeRE =
    [NSRegularExpression regularExpressionWithPattern:@"^kvg:([a-f0-9]{5})$"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:nil];
    
    RXMLElement *characterGroup = [[[root children:@"g"] objectAtIndex:0] child:@"g"];
    
    // Get the unicode character
    NSString *idAttr = [characterGroup attribute:@"id"];
    // Check if idAttr is valid
    NSTextCheckingResult *valid = [characterCodeRE firstMatchInString:idAttr options:0 range:NSMakeRange(0, [idAttr length])];
    
    return valid;
}

@end
