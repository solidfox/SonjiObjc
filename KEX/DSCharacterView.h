//
//  DSCharacterView.h
//  KEX
//
//  Created by Daniel Schlaug on 3/3/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KVG_CHARACTER_DIMENSION 109.0

@interface DSCharacterView : UIView

@property (nonatomic) CGSize inputCharacterDimensions;
@property (nonatomic, readonly) NSInteger numberOfStrokes;
@property (nonatomic) NSInteger shownStrokes;

- (void)addStroke:(UIBezierPath *)path;
- (void)removeStrokes;


@end
