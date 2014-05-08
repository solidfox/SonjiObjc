//
//  DSUserCharacterStroke.m
//  KEX
//
//  Created by Daniel Schlaug on 5/3/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "DSUserCharacterStroke.h"
#import "UIBezierPath+Comparison.h"

@interface DSUserCharacterStroke ()

@property (strong, nonatomic, readwrite) UIBezierPath *path;

@end

@implementation DSUserCharacterStroke

- (void)addPoint:(CGPoint)point
{
    if (!self.path) {
        self.path = [[UIBezierPath alloc] init];
        [self.path moveToPoint:point];
    } else {
        [self.path addLineToPoint:point];
    }
}

- (CGFloat)gradeWithDesiredStroke:(KVGStroke *)desiredStroke
{
    CGFloat yRatio = KVGCharacterSize.height / self.size.height;
    CGFloat xRatio = KVGCharacterSize.width / self.size.width;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(xRatio, yRatio);
    
    CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(self.path.CGPath, &transform);
    
    UIBezierPath *scaledBezPath = [UIBezierPath bezierPathWithCGPath:scaledPath];
    
    return [desiredStroke.path compareTo:scaledBezPath];
}

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    
    self.size = size;
    
    return self;
}

@end
