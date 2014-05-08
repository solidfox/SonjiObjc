//
//  UIBezierPath+Comparison.m
//  KEX
//
//  Created by Daniel Schlaug on 4/11/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "UIBezierPath+Comparison.h"
#import "UIBezierPath-Points.h"

@implementation UIBezierPath (Comparison)

-(CGFloat)compareTo:(UIBezierPath *)otherPath
{
    // TODO Normalize size
    // TODO Normalize rotation
    // TODO Normalize position
    // Compare points
    NSArray *points = [otherPath points];
    
    NSUInteger averageDistance = [self averageDistanceToPoints:points withDetail:0.5]; //TODO UGLY Remove these magic numbers
    
    return averageDistance;
};

-(CGFloat) averageDistanceToPoints:(NSArray *)points
                        withDetail:(CGFloat)detail
{
    NSUInteger  nPoints                     = [points count];
    // Distance at which to start binary search
    CGFloat     currentDistance             = 10;
    // Record of the distances so far
    CGFloat     distances[nPoints];  for (int i = 0; i < nPoints; i++) {distances[i] = CGFLOAT_MAX;}
    // Indication of which points already have a distance of satisfactory detail
    BOOL        done[nPoints];       memset(done, 0, sizeof(done));
    int         nDone                       = 0;
    
    
    while (nDone < nPoints) {
        CGFloat nextDistance = currentDistance / 2;
        int i = -1;
        int containedPoints = 0;
        CGPathRef shape = CGPathCreateCopyByStrokingPath(self.CGPath,
                                                         NULL,
                                                         currentDistance,
                                                         kCGLineCapRound,
                                                         kCGLineJoinMiter,
                                                         currentDistance);
        
        for (NSValue *pointValue in points)
        {
            i++;
            CGFloat *pointDistance = &distances[i];
            
            if (!done[i]) {
                CGPoint point = [pointValue CGPointValue];
                
                if (CGPathContainsPoint(shape, NULL, point, true)) {
                    containedPoints++;
                    if (*pointDistance > currentDistance) {
                        *pointDistance = currentDistance;
                    }
                } else if (*pointDistance == CGFLOAT_MAX) {
                    nextDistance = currentDistance * 2;
                } else if (*pointDistance <= currentDistance + detail) {
                    done[i] = YES;
                    nDone++;
                } else {
                    nextDistance = (*pointDistance/2 + currentDistance/2);
                }
            }
        }
        NSAssert(currentDistance != nextDistance, @"Current distance was equal to next distance: %f", currentDistance);
        currentDistance = nextDistance;
    }
    
    CGFloat summedDistance = 0.0;
    for (int i = 0; i < nPoints; i++) {
        summedDistance += distances[i];
    }
    return summedDistance / nPoints;
}

@end
