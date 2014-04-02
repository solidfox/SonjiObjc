//
//  DSCharacterView.m
//  KEX
//
//  Created by Daniel Schlaug on 3/3/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "DSCharacterView.h"

@interface DSCharacterView ()

@property (nonatomic, strong) NSMutableArray *strokes;
@property (nonatomic, readwrite) NSInteger numberOfStrokes;

@end

@implementation DSCharacterView

#pragma mark - Properties

- (void)setInputCharacterDimensions:(CGSize)newDimensions
{
    _inputCharacterDimensions = newDimensions;
    [self setNeedsDisplay];
}

- (NSMutableArray *)strokes
{
    if (!_strokes) {
        _strokes = [[NSMutableArray alloc] init];
    }
    return _strokes;
}

- (void)addStroke:(UIBezierPath *)path
{
    [self.strokes addObject:path];
    self.numberOfStrokes++;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGFloat xFactor = self.bounds.size.width / self.inputCharacterDimensions.width;
    CGFloat yFactor = self.bounds.size.height / self.inputCharacterDimensions.height;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), xFactor, yFactor);
    [[UIColor blackColor] setStroke];
    
    for (UIBezierPath *stroke in self.strokes) {
        NSLog(@"%fx%f", xFactor, yFactor);
        [stroke stroke];
    }
}

#pragma mark - Initialization

- (void)setup
{
    _inputCharacterDimensions = CGSizeMake(KVG_CHARACTER_DIMENSION, KVG_CHARACTER_DIMENSION);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    if (_inputCharacterDimensions.height == 0 && _inputCharacterDimensions.width == 0) {
        _inputCharacterDimensions = self.bounds.size;
    }
}

@end
