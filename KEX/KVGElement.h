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

@interface KVGElement : NSObject

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


@property (nonatomic, readonly) unichar mostSimilarUnicode;    // kvg:element attribute
@property (nonatomic, readonly) unichar semanticUnicode;       // kvg:original attribute
@property (nonatomic, readonly) KVGPosition position;           // kvg:position attribute
@property (nonatomic, readonly) KVGRadical radical;             // kvg:radical attribute
@property (nonatomic, readonly) bool variant;                   // kvg:variant attribute
@property (nonatomic, readonly) bool partial;                   // kvg:partial attribute
@property (nonatomic, readonly) NSInteger number;               // kvg:number attribute
@property (strong, nonatomic, readonly) NSArray *childElements;
@property (strong, nonatomic, readonly) KVGElement *parentElement;
@property (strong, nonatomic, readonly) NSArray *rootStrokes;

/** Goes through the element tree, finding all strokes of the element.
 
 @return An array of the strokes in the element, sorted by stroke order.
 */
- (NSArray *)strokes;

+ (KVGElement *)elementFromRXML:(RXMLElement *)elementNode;

@end
