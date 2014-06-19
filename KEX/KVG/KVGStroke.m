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
@property (readwrite) unichar type;
@property (readwrite) NSInteger strokeOrder;

@end

@implementation KVGStroke

// Designated initializer
- (id)initFromRXML:(RXMLElement *)pathElement
{
    self = [self init];
    
    //Parse stroke order
    NSString *idAttribute = [pathElement attribute:@"id"];
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@".*-s([1-9][0-9]?)(-.*|$)" options:0 error:nil];
    NSString *strokeOrderString = [regExp stringByReplacingMatchesInString:idAttribute options:0 range:(NSRange){0, [idAttribute length]} withTemplate:@"$1"];
    self.strokeOrder = [strokeOrderString integerValue];
    NSAssert(self.strokeOrder != 0, @"Couldn't parse stroke order: %@", idAttribute);
    
    //Parse stroke path
    CGPathRef cgPath = [PocketSVG pathFromDAttribute:[pathElement attribute:@"d"]];
    self.path = [UIBezierPath bezierPathWithCGPath:cgPath];
    
    //Parse stroke type
    self.type = [[pathElement attribute:@"type"] characterAtIndex:0];
    
    return self;
}

@end
