//
//  KVGElement.m
//  KEX
//
//  Created by Daniel Schlaug on 3/1/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "KVGElement.h"

@interface KVGElement ()

@property (retain, nonatomic, readwrite) NSString *mostSimilarUnicode;
@property (retain, nonatomic, readwrite) NSString *semanticUnicode;
@property (readwrite) KVGPosition position;
@property (readwrite) KVGRadical radical;
@property (readwrite) bool variant;
@property (readwrite) bool partial;
@property (readwrite) NSInteger number;

@end

@implementation KVGElement

#pragma mark - Properties

@dynamic mostSimilarUnicode;
@dynamic semanticUnicode;
@dynamic position;
@dynamic radical;
@dynamic variant;
@dynamic partial;
@dynamic number;
@dynamic rootStrokes;

@dynamic childElements;
@dynamic parentElement;



#pragma mark - Stroke stuff

- (NSArray *)strokes
{
    NSMutableArray *strokes = [[NSMutableArray alloc] init];
    for (KVGStroke *stroke in self.rootStrokes) {
        [strokes addObject:stroke];
    }
    for (KVGElement *element in self.childElements) {
        [strokes addObjectsFromArray:[element strokes]];
    }
    return strokes;
//    return [strokes sortedArrayUsingComparator:^NSComparisonResult(KVGStroke *obj1, KVGStroke *obj2) {
//        if (obj1.strokeOrder > obj2.strokeOrder) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
//        
//        if (obj1.strokeOrder < obj2.strokeOrder) {
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        return (NSComparisonResult)NSOrderedSame;
//    }];
}

#pragma mark - Initialization

+ (KVGElement *)elementFromRXML:(RXMLElement *)elementNode inManagedObjectContext:(NSManagedObjectContext *)context
{
    KVGElement *element = [KVGElement newKVGElementInManagedObjectContext:context];
    
    [element readAttributesFrom:elementNode];
        
    // Read the children
    [elementNode iterate:@"*" usingBlock:^(RXMLElement *elementChildNode){
        if ([elementChildNode.tag isEqualToString:@"g"])
        {
            KVGElement *newElement = [KVGElement elementFromRXML:elementChildNode inManagedObjectContext:context];
            [element addChildElementsObject:newElement];
            
        } else if ([elementChildNode.tag isEqualToString:@"path"]) {
            KVGStroke *stroke = [KVGStroke strokeFromRXML:elementChildNode
                                   inManagedObjectContext:context];
            [element addRootStrokesObject:stroke];
            
        }
        
    }];
    
    
    return element;
}

+ (KVGElement *)newKVGElementInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"KVGElement"
                                            inManagedObjectContext:context];
}

#pragma mark - Private methods

- (void)readAttributesFrom:(RXMLElement *)XMLRepresentation {
    self.mostSimilarUnicode = [XMLRepresentation attribute:@"element"];
    self.semanticUnicode = [XMLRepresentation attribute:@"original"];
    
    NSString *position = [XMLRepresentation attribute:@"position"];
    if (!position) {self.position = KVGPositionNone;}
    else if ([position isEqualToString:@"left,"])   {self.position = KVGPositionLeft;}
    else if ([position isEqualToString:@"right,"])  {self.position = KVGPositionRight;}
    else if ([position isEqualToString:@"top,"])    {self.position = KVGPositionTop;}
    else if ([position isEqualToString:@"bottom,"]) {self.position = KVGPositionBottom;}
    else if ([position isEqualToString:@"nyo,"])    {self.position = KVGPositionNyo;}
    else if ([position isEqualToString:@"tare,"])   {self.position = KVGPositionTare;}
    else if ([position isEqualToString:@"kamae,"])  {self.position = KVGPositionKamae;}
    else if ([position isEqualToString:@"kamae1,"]) {self.position = KVGPositionKamae1;}
    else if ([position isEqualToString:@"kamae2"])  {self.position = KVGPositionKamae2;}
    
    NSString *radical = [XMLRepresentation attribute:@"radical"];
    if (!radical) {self.radical = KVGPositionNone;}
    else if ([radical isEqualToString:@"general"])  {self.radical = KVGRadicalGeneral;}
    else if ([radical isEqualToString:@"nelson"])   {self.radical = KVGRadicalNelson;}
    else if ([radical isEqualToString:@"tradit"])   {self.radical = KVGRadicalTradit;}
    
    NSString *variant = [XMLRepresentation attribute:@"variant"];
    if ([variant isEqualToString:@"true"]) {self.variant = true;}
    else {self.variant = false;}
    
    NSString *partial = [XMLRepresentation attribute:@"partial"];
    if ([partial isEqualToString:@"true"]) {self.partial = true;}
    else {self.partial = false;}
    
    self.number = [XMLRepresentation attributeAsInt:@"number"];
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"KVGElement: %@\nVariant:%@\nNumber:%ld", self.mostSimilarUnicode, self.variant ? @"true" : @"false", (long)self.number];
}

@end