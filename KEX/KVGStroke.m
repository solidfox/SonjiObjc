//
//  KVGStroke.m
//  KEX
//
//  Largely based on code from PocketSVG: https://github.com/arielelkin/PocketSVG
//  Copyright (c) 2013 Ponderwell, Ariel Elkin, and Contributors
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Created by Daniel Schlaug on 3/2/14.
//

#import "KVGStroke.h"
#import "RXMLElement.h"
#import "PocketSVG.h"

@interface KVGStroke ()

@property (strong, nonatomic, readwrite) UIBezierPath *path;

@end

@implementation KVGStroke

@dynamic path;

@dynamic strokeOrder;

+ (KVGStroke *)strokeFromRXML:(RXMLElement *)pathElement inManagedObjectContext:(NSManagedObjectContext *)context
{
    KVGStroke *stroke = [KVGStroke newStrokeInManagedObjectContext:context];
    
    CGPathRef cgPath = [PocketSVG pathFromDAttribute:[pathElement attribute:@"d"]];
    stroke.path = [UIBezierPath bezierPathWithCGPath:cgPath];
    
    return stroke;
}

+ (KVGStroke *)newStrokeInManagedObjectContext:context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"KVGStroke"
                                         inManagedObjectContext:context];
}

@end
