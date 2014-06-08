//
//  DSStrokeSonifier.h
//  KEX
//
//  Created by Daniel Schlaug on 4/16/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSStrokeSonifier : NSObject

@property (nonatomic) CGPoint currentPosition;
@property (nonatomic) CGPoint currentVelocity;
@property (nonatomic) CGRect bounds;

- (id)initWithFrame:(CGRect)frame;

- (void)turnOn;
- (void)turnOff;

@end
