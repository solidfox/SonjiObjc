//
//  KVGCharacter+Creation.h
//  KEX
//
//  Created by Daniel Schlaug on 3/17/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "KVGCharacter.h"

@interface KVGCharacter (Creation)

+ (id)characterFromSVGFile:(NSString *)filename
    inManagedObjectContext:(NSManagedObjectContext *)context;
+ (id)characterFromSVGData:(NSData *)data
    inManagedObjectContext:(NSManagedObjectContext *)context;

/** Recurses through all the elements of the character to find all the strokes.
 @return An NSArray of KVGStroke objects representing all strokes of the character. Stroke order is preserved through the index of each stroke.
 */
- (NSArray *)strokes;

@end
