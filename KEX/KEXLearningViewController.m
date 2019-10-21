//
//  DSViewController.m
//  KEX
//
//  Created by Daniel Schlaug on 2/20/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "KEXLearningViewController.h"
#import "DSCharacterView.h"
#import "KVGRepository.h"
#import "DSStrokeSonifier.h"
#import "DSUserCharacterStroke.h"
#import <BezierKit/BezierKit.h>
#import "KEX-Swift.h"


@interface KEXLearningViewController ()

@property (weak, nonatomic) IBOutlet DSCharacterView *desiredKanjiView;
@property (strong, nonatomic) DSCharacterView *userKanjiView;
@property (weak, nonatomic) IBOutlet UISlider *strokesSlider;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *velocityLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *kanjiButtons;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *pointDisplay;

@property (strong, nonatomic) KVGRepository *kanjiRepo;

@property (strong, nonatomic) KVGEntry *desiredKanji;
@property (strong, nonatomic) KVGStroke *desiredStroke;
@property (strong, nonatomic) DSUserCharacterStroke *userStroke;
@property (nonatomic) NSUInteger nSuccessfulUserStrokes;

@property (strong, nonatomic) DSStrokeSonifier *sonifier;

@end

@implementation KEXLearningViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userKanjiView = [[DSCharacterView alloc] initWithFrame:self.desiredKanjiView.frame];
    self.kanjiRepo = [[KVGRepository alloc] initWithDefaultLocalCacheURL];
    
    self.desiredKanjiView.inputCharacterDimensions = KVGCharacterSize;
    self.userKanjiView.opaque = NO;
    [self.view addSubview:self.userKanjiView];
    
    for (UIButton *button in self.kanjiButtons) {
        unichar character = [[button titleForState:UIControlStateNormal] characterAtIndex:0];
        [self.kanjiRepo loadCharacterDataFor:character completionHandler:^(BOOL success){}];
//        CharacterMetadataRepository *repo = [[CharacterMetadataRepository alloc] init];
    }
    
    NSAssert(self.nSuccessfulUserStrokes == 0, @"Weird initialization of nSuccessfulUserStrokes");
}

- (void)viewDidLayoutSubviews
{
    self.userKanjiView.frame = self.desiredKanjiView.frame;
    
    self.sonifier = [[DSStrokeSonifier alloc] initWithFrame:self.desiredKanjiView.frame];
}

- (void)setUserKanjiView:(DSCharacterView *)kanjiCanvas
{
    _userKanjiView = kanjiCanvas;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedPan:)];
    [kanjiCanvas addGestureRecognizer:panRecognizer];
}

- (void)recognizedPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint currentPosition = [recognizer locationInView:self.userKanjiView];
    CGPoint currentVelocity = [recognizer velocityInView:self.userKanjiView];
    
    
    CGFloat combinedVelocity = sqrt(currentVelocity.x * currentVelocity.x + currentVelocity.y * currentVelocity.y);
    CGFloat volume = MIN(1, log(combinedVelocity/2)/log(700));
    self.velocityLabel.text = [NSString stringWithFormat:@"%f", volume];
    
    self.sonifier.currentVelocity = currentVelocity;
    self.sonifier.currentPosition = currentPosition;
    
    NSUInteger desiredStrokeCount = [self desiredStrokeCount];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.userStroke addPoint:currentPosition];
    } else if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.userStroke = [[DSUserCharacterStroke alloc] initWithSize:self.desiredKanjiView.frame.size];
        [self.userStroke addPoint:currentPosition];
        [self.sonifier turnOn];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.sonifier turnOff];
        [self.userStroke addPoint:currentPosition];
        [self gradeUserStroke];
    }
    
    if (self.userKanjiView.numberOfStrokes == desiredStrokeCount) {
        [self.userKanjiView replaceStrokeWithStrokeOrder:desiredStrokeCount withStroke:self.userStroke.path];
    } else {
        [self.userKanjiView addStroke:self.userStroke.path];
    }
}

- (void)gradeUserStroke
{
    NSAssert(self.userStroke != nil, @"Could not grade user stroke as it was nil!");
    
    if (self.desiredStroke) {
        CGFloat grade = [self.userStroke gradeWithDesiredStroke:self.desiredStroke];
        
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %f", grade];
        
        if (grade < 15) {
            self.scoreLabel.textColor = [UIColor greenColor];
            self.nSuccessfulUserStrokes++;
        } else {
            self.scoreLabel.textColor = [UIColor redColor];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)strokeSliderChanged:(UISlider *)sender {
    self.desiredKanjiView.shownStrokes = sender.value;
}

- (IBAction)traceStrokeSliderChanged:(UISlider *)sender {
    CGPoint point = [self.desiredStroke.path pointAtPercent:sender.value withSlope:nil];
    CGRect frame = self.pointDisplay.frame;
    frame.origin = point;
    self.pointDisplay.frame = frame;
}

- (IBAction)kanjiButtonPushed:(UIButton *)sender {
    unichar unicodeCharacter = [[sender titleForState:UIControlStateNormal] characterAtIndex:0];
    KVGEntry *character = [self.kanjiRepo KVGCharacterFor:unicodeCharacter];
    [self setDesiredKanji:character];
}

- (KVGStroke *)desiredStroke
{
    _desiredStroke = nil;
    
    NSInteger desiredStrokeCount = [self desiredStrokeCount];
    
    if (desiredStrokeCount <= [self.desiredKanji.strokes count]) {
        _desiredStroke = [self.desiredKanji strokeWithStrokeCount:[self desiredStrokeCount]];
    }
    
    return _desiredStroke;
}

- (NSInteger)desiredStrokeCount
{
    return self.nSuccessfulUserStrokes + 1;
}

- (void)setDesiredKanji:(KVGEntry *)desiredKanji
{
    [self.desiredKanjiView removeStrokes];
    for (KVGStroke *stroke in [desiredKanji strokes]) {
        [self.desiredKanjiView addStroke:stroke.path];
    }
    
    self.nSuccessfulUserStrokes = 0;
    [self.userKanjiView removeStrokes];
    
    self.strokesSlider.maximumValue = [desiredKanji.strokes count];
    self.strokesSlider.value = self.strokesSlider.maximumValue;
    
    _desiredKanji = desiredKanji;
}

@end
