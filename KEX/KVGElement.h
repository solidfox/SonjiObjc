//
//  KVGElement.h
//  KEX
//
//  Created by Daniel Schlaug on 3/1/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXMLElement.h"
#import "KVGStroke.h"
#import <CoreData/CoreData.h>

@interface KVGElement : NSManagedObject

typedef NS_ENUM(int16_t, KVGRadical) {
    KVGRadicalNone = 0,
    KVGRadicalGeneral = 1,
    KVGRadicalNelson = 2,
    KVGRadicalTradit = 3
};

typedef NS_ENUM(int16_t, KVGPosition) {
    KVGPositionNone = 0,
	KVGPositionLeft = 1,
	KVGPositionRight = 2,
	KVGPositionTop = 3,
	KVGPositionBottom = 4,
	KVGPositionNyo = 5,
	KVGPositionTare = 6,
	KVGPositionKamae = 7,
	KVGPositionKamae1 = 8,
	KVGPositionKamae2 = 9
};


@property (retain, nonatomic, readonly) NSString *mostSimilarUnicode; // kvg:element attribute
@property (retain, nonatomic, readonly) NSString *semanticUnicode; // kvg:original attribute
@property (readonly) KVGPosition position;
@property (readonly) KVGRadical radical;
@property (readonly) bool variant;
@property (readonly) bool partial;
@property (readonly) NSInteger number;
@property (nonatomic, retain) NSSet *childElements;
@property (nonatomic, retain) KVGElement *parentElement;
@property (nonatomic, retain) NSSet *rootStrokes;

/** Goes through the element tree, finding all strokes of the element.
 
 @return An array of the strokes in the element, sorted by stroke order.
 */
- (NSArray *)strokes;

+ (KVGElement *)elementFromRXML:(RXMLElement *)elementNode inManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface KVGElement (CoreDataGeneratedAccessors)

- (void)addChildElementsObject:(KVGElement *)value;
- (void)removeChildElementsObject:(KVGElement *)value;
- (void)addChildElements:(NSSet *)values;
- (void)removeChildElements:(NSSet *)values;

- (void)addRootStrokesObject:(KVGStroke *)value;
- (void)removeRootStrokesObject:(KVGStroke *)value;
- (void)addRootStrokes:(NSSet *)values;
- (void)removeRootStrokes:(NSSet *)values;

@end
