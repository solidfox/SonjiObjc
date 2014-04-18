//
//  DSKanji.h
//  KEX
//
//  Created by Daniel Schlaug on 2/24/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVGElement.h"
#import <UIKit/UIKit.h>

/** This class represents a KanjiVG character. It contains metadata about the character and a tree of the characters elements and leaf strokes.
 
    The class is a subclass of NSManagedObject and so can easily be stored in a CoreData database. See KVGCache for an implementation of such a database.
 */

@interface KVGCharacter : NSObject

@property (nonatomic, readonly) unichar character;
@property (nonatomic, strong, readonly) KVGElement *element;


+ (id)characterFromSVGFile:(NSString *)filename;
+ (id)characterFromSVGData:(NSData *)data;

/** Recurses through all the elements of the character to find all the strokes.
 @return An NSArray of KVGStroke objects representing all strokes of the character. Stroke order is preserved through the index of each stroke.
 */
- (NSArray *)strokes;


@end