//
//  KVGStroke.h
//  KEX
//
//  Created by Daniel Schlaug on 3/2/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVGConstants.h"
#import <UIKit/UIKit.h>
#import "RXMLElement.h"
#import <CoreData/CoreData.h>

@interface KVGStroke : NSObject

@property (strong, nonatomic, readonly) UIBezierPath *path;
@property (readonly) unichar type;
@property (readonly) NSInteger strokeOrder;

- (id)initFromRXML:(RXMLElement *)pathElement;

@end