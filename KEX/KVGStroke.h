//
//  KVGStroke.h
//  KEX
//
//  Created by Daniel Schlaug on 3/2/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RXMLElement.h"
#import <CoreData/CoreData.h>

@interface KVGStroke : NSManagedObject

@property (strong, nonatomic, readonly) UIBezierPath *path;
@property (readonly) NSInteger strokeOrder;

+ (KVGStroke *)strokeFromRXML:(RXMLElement *)pathElement
       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
