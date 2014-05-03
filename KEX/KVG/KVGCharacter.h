//
//  KVGCharacter.h
//
//  Created by Daniel Schlaug on 2/24/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVGConstants.h"
#import "KVGElement.h"
#import <UIKit/UIKit.h>

/**
 *  This class represents a KanjiVG character. It contains metadata about the character and a tree of the characters elements and leaf strokes.
 */

@interface KVGCharacter : NSObject

@property (nonatomic, readonly) unichar character;
@property (nonatomic, readonly, strong) KVGElement *element;

+ (id)characterFromSVGFile:(NSString *)filename;
+ (id)characterFromSVGData:(NSData *)data;

/**
 *  Recurses through all the elements of the character to find all the strokes.
 *
 *  @return An NSArray of KVGStroke objects representing all strokes of the character. Stroke order is preserved through the index of each stroke.
 */
- (NSArray *)strokes;

/**
 *  <#Description#>
 *
 *  @param strokeCount <#strokeCount description#>
 *
 *  @return <#return value description#>
 */
- (KVGStroke *)strokeWithStrokeCount:(NSInteger)strokeCount;

@end