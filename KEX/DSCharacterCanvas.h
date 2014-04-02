//
//  DSCharacterCanvas.h
//  KEX
//
//  Created by Daniel Schlaug on 3/7/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CMUnistrokeGestureRecognizer.h"

@interface DSCharacterCanvas : UIView <CMUnistrokeGestureRecognizerDelegate>

- (void)unistrokeRecognizer:(CMUnistrokeGestureRecognizer *)recognizer;
- (void)addStroke:(UIBezierPath *)path;

@end