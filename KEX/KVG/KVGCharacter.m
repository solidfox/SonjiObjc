//
//  DSKanji.m
//  KEX
//
//  Created by Daniel Schlaug on 2/24/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "KVGCharacter.h"
#import "RXMLElement.h"


@interface KVGCharacter ()

@property (nonatomic, readwrite) unichar character;
@property (strong, nonatomic, readwrite) KVGElement *element;

@end

@implementation KVGCharacter

- (NSArray *)strokes
{
    return [self.element strokes];
}

- (KVGStroke *)strokeWithStrokeCount:(NSInteger)strokeCount
{
    return [self.strokes objectAtIndex:strokeCount - 1];
}

#pragma mark Initialization

+ (KVGCharacter *)characterFromSVGFile:(NSString *)filename
{
    RXMLElement *rootNode = [RXMLElement elementFromXMLFile:[NSString stringWithFormat:@"%@.svg", filename]];
    
    return [[KVGCharacter alloc] initFromRXMLElement:rootNode];
}

+ (KVGCharacter *)characterFromSVGData:(NSData *)data
{
    KVGCharacter *character = nil;
    
    if (data) {
        RXMLElement *rootNode = [RXMLElement elementFromXMLData:data];
        
        character = [[KVGCharacter alloc] initFromRXMLElement:rootNode];
    }
    
    return character;
}

- (id)initFromRXMLElement:(RXMLElement *)rootNode
{
    self = [self init];
    
    if ([KVGCharacter isValidKanjiVGFile:rootNode]){
        
        __block RXMLElement *strokePathsNode = nil;
        [rootNode iterate:@"g" usingBlock:^(RXMLElement *group) {
            if ([[group attribute:@"id"] hasPrefix:@"kvg:StrokePaths"]) {
                strokePathsNode = group;
            }
        }];
        
        RXMLElement *characterGroup = [strokePathsNode child:@"g"];
        
        self.character = [[characterGroup attribute:@"element"] characterAtIndex:0];
        
        self.element = [KVGElement elementFromRXML:characterGroup];
    }
    
    return self;
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
