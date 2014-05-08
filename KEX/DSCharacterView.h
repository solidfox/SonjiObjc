//
//  DSCharacterView.h
//  KEX
//
//  Created by Daniel Schlaug on 3/3/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSCharacterView : UIView

@property (nonatomic) CGSize inputCharacterDimensions;
@property (nonatomic, readonly) NSInteger numberOfStrokes;
@property (nonatomic) NSInteger shownStrokes;

- (void)addStroke:(UIBezierPath *)path;
- (void)replaceStrokeWithStrokeOrder:(NSInteger)index withStroke:(UIBezierPath *)path;
- (void)removeStrokes;

@end
