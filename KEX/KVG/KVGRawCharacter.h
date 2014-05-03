//
//  KVGRawCharacter.h
//  KEX
//
//  Created by Daniel Schlaug on 4/19/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVGConstants.h"
#import <CoreData/CoreData.h>


@interface KVGRawCharacter : NSManagedObject

@property (nonatomic, retain) NSString * unicodeCharacter;
@property (nonatomic, retain) NSData * xmlData;

@end
