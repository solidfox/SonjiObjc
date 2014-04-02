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
#import <CoreData/CoreData.h>

/** This class represents a KanjiVG character. It contains metadata about the character and a tree of the characters elements and leaf strokes.
 
    The class is a subclass of NSManagedObject and so can easily be stored in a CoreData database. See KVGCache for an implementation of such a database.
 */

@interface KVGCharacter : NSManagedObject

@property (nonatomic, retain) NSString *character;
@property (nonatomic, retain) KVGElement *element;

@end