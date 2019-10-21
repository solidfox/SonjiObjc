//
//  DSUserCharacterStroke.h
//
//
//  Created by Daniel Schlaug on 5/3/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVGConstants.h"
#import "KEX-Swift.h"

@interface DSUserCharacterStroke : NSObject

@property (strong, nonatomic, readonly) UIBezierPath *path;
@property (nonatomic) CGSize size;

- (void)addPoint:(CGPoint)point;

- (CGFloat)gradeWithDesiredStroke:(KVGStroke *)template;

- (id)initWithSize:(CGSize)size;

@end
