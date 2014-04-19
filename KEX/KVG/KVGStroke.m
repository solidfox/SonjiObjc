//
//  KVGStroke.m
//  KEX
//
//  Created by Daniel Schlaug on 3/2/14.
//

#import "KVGStroke.h"
#import "RXMLElement.h"
#import "PocketSVG.h"

@interface KVGStroke ()

@property (strong, nonatomic, readwrite) UIBezierPath *path;
@property (readwrite) NSInteger strokeOrder;

@end

@implementation KVGStroke

// Designated initializer
- (id)initFromRXML:(RXMLElement *)pathElement
{
    self = [self init];
    
    CGPathRef cgPath = [PocketSVG pathFromDAttribute:[pathElement attribute:@"d"]];
    self.path = [UIBezierPath bezierPathWithCGPath:cgPath];
    
    return self;
}

@end
