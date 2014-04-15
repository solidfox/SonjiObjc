//
//  DSCharacterCanvas.m
//  KEX
//
//  Created by Daniel Schlaug on 3/7/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "DSCharacterCanvas.h"
#import "DSCharacterView.h"

@interface DSCharacterCanvas ()

@property (nonatomic, strong) DSCharacterView *character;
@property (nonatomic, strong) NSMutableArray *targetPaths;
@property (nonatomic, strong) NSMutableArray *drawnPaths;
@property (nonatomic, strong) UIBezierPath *currentDrawnPath;
@property (nonatomic, strong) CMUnistrokeGestureRecognizer *unistrokeRecognizer;

@end

@implementation DSCharacterCanvas {
@private
    CGAffineTransform templatePathScaler;
}

- (void)addStroke:(UIBezierPath *)path
{
    if (self.character.numberOfStrokes == 0) {
        [self setRecognizerStroke:path];
    }
    [self.targetPaths addObject:path];
    [self.character addStroke:path];
}

- (NSMutableArray *)drawnPaths
{
    if (!_drawnPaths)
    {
        _drawnPaths = [[NSMutableArray alloc] init];
    }
    return _drawnPaths;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
    for (UIBezierPath *path in self.drawnPaths) {
        [path stroke];
    }
    
    // DEBUG drawing
    UIBezierPath *targetPath = [self.targetPaths objectAtIndex:[self.drawnPaths count]];
    targetPath = [UIBezierPath bezierPathWithCGPath:targetPath.CGPath];
    [targetPath applyTransform:templatePathScaler];
    [[UIColor redColor] setStroke];
    [targetPath stroke];
    
    
    [[UIColor blueColor] setStroke];
    [self.currentDrawnPath stroke];
}

- (void)unistrokeRecognizer:(CMUnistrokeGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateRecognized)
    {
        if (recognizer.result.recognizedStrokeScore > 0.85) {
            [self.drawnPaths addObject:self.currentDrawnPath];
            if ([self.drawnPaths count] != [self.targetPaths count]) {
                [self setRecognizerStroke:[self.targetPaths objectAtIndex:[self.drawnPaths count]+1]];
            } else {
                [self.unistrokeRecognizer clearAllUnistrokes];
            }
        }
        
        self.currentDrawnPath = nil;
        
        [self setNeedsDisplay];
    }
}

- (void) setRecognizerStroke:(UIBezierPath *)path
{
    [self.unistrokeRecognizer clearAllUnistrokes];
    UIBezierPath *scaledTemplatePath = [UIBezierPath bezierPathWithCGPath:path.CGPath];
    [scaledTemplatePath applyTransform:templatePathScaler];
    [self.unistrokeRecognizer registerUnistrokeWithName:@"recognized" bezierPath:scaledTemplatePath];
}

#pragma mark - GestureRecognizer delegated methods

- (void)unistrokeGestureRecognizer:(CMUnistrokeGestureRecognizer *)unistrokeGestureRecognizer isEvaluatingStrokePath:(UIBezierPath *)strokePath
{
    self.currentDrawnPath = strokePath;
    [self setNeedsDisplay];
}

- (void)unistrokeGestureRecognizerDidFailToRecognize:(CMUnistrokeGestureRecognizer *)unistrokeGestureRecognizer
{
    self.currentDrawnPath = nil;
    [self setNeedsDisplay];
}

#pragma mark - Setters, getters

- (NSMutableArray *)targetPaths
{
    if (!_targetPaths) {
        _targetPaths = [[NSMutableArray alloc] init];
    }
    return _targetPaths;
}


#pragma mark - Initialization

- (void)setup
{
    self.character = [[DSCharacterView alloc] initWithFrame:self.bounds];
    [self addSubview:self.character];
    self.character.opaque = false;
    
    templatePathScaler = CGAffineTransformMakeScale(self.bounds.size.width /KVG_CHARACTER_DIMENSION, self.bounds.size.height / KVG_CHARACTER_DIMENSION);
    
    self.unistrokeRecognizer = [[CMUnistrokeGestureRecognizer alloc] initWithTarget:self action:@selector(unistrokeRecognizer:)];
    [self addGestureRecognizer:self.unistrokeRecognizer];
    self.unistrokeRecognizer.unistrokeDelegate = self;
    self.unistrokeRecognizer.rotationNormalisationEnabled = false;
    self.unistrokeRecognizer.sizeNormalisationEnabled = false;
    self.unistrokeRecognizer.minimumScoreThreshold = 0.5;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)init
{
    self = [super init];
    if (self){
        [self setup];
    }
    return self;
}

@end
