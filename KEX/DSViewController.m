//
//  DSViewController.m
//  KEX
//
//  Created by Daniel Schlaug on 2/20/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "DSViewController.h"
#import "KVGCharacter.h"
#import "DSCharacterView.h"
#import "KVGRepository.h"
#import "DSStrokeSonifier.h"
#import "DSUserCharacterStroke.h"


@interface DSViewController ()

@property (weak, nonatomic) IBOutlet DSCharacterView *desiredKanjiView;
@property (strong, nonatomic) DSCharacterView *userKanjiView;
@property (weak, nonatomic) IBOutlet UISlider *strokesSlider;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *kanjiButtons;

@property (strong, nonatomic) KVGRepository *kanjiRepo;

@property (strong, nonatomic) KVGCharacter *desiredKanji;
@property (strong, nonatomic) KVGStroke *desiredStroke;
@property (strong, nonatomic) DSUserCharacterStroke *userStroke;
@property (nonatomic) NSUInteger nSuccessfulUserStrokes;

@property (strong, nonatomic) DSStrokeSonifier *sonifier;

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sonifier = [[DSStrokeSonifier alloc] init];
    
    self.userKanjiView = [[DSCharacterView alloc] initWithFrame:self.desiredKanjiView.frame];
    self.kanjiRepo = [[KVGRepository alloc] initWithDefaultLocalCacheURL];
    
    self.desiredKanjiView.inputCharacterDimensions = KVGCharacterSize;
    self.userKanjiView.opaque = NO;
    [self.view addSubview:self.userKanjiView];
    
    for (UIButton *button in self.kanjiButtons) {
        unichar character = [[button titleForState:UIControlStateNormal] characterAtIndex:0];
        [self.kanjiRepo loadCharacterDataFor:character completionHandler:^(BOOL success){}];
    }
    
    NSAssert(self.nSuccessfulUserStrokes == 0, @"Weird initialization of nSuccessfulUserStrokes");
}

- (void)viewDidLayoutSubviews
{
    self.userKanjiView.frame = self.desiredKanjiView.frame;
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
    NSUInteger desiredStrokeCount = [self desiredStrokeCount];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.userStroke addPoint:currentPosition];
    } else if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.userStroke = [[DSUserCharacterStroke alloc] initWithSize:self.desiredKanjiView.frame.size];
        [self.userStroke addPoint:currentPosition];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.userStroke addPoint:currentPosition];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self gradeUserStroke];
        [self.sonifier turnOff];
    } else {
        self.sonifier.currentPosition = currentPosition;
    }
    
    if (self.userKanjiView.numberOfStrokes == desiredStrokeCount) {
        [self.userKanjiView replaceStrokeWithStrokeOrder:desiredStrokeCount withStroke:self.userStroke.path];
    } else {
        [self.userKanjiView addStroke:self.userStroke.path];
    }
}

- (void)gradeUserStroke
{
    NSAssert(self.userStroke != nil, @"userStroke was nil!");
    
    CGFloat grade = [self.userStroke gradeWithDesiredStroke:self.desiredStroke];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %f", grade];
    
    if (grade < 15) {
        self.scoreLabel.textColor = [UIColor greenColor];
        self.nSuccessfulUserStrokes++;
    } else {
        self.scoreLabel.textColor = [UIColor redColor];
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

- (IBAction)kanjiButtonPushed:(UIButton *)sender {
    unichar unicodeCharacter = [[sender titleForState:UIControlStateNormal] characterAtIndex:0];
    KVGCharacter *character = [self.kanjiRepo KVGCharacterFor:unicodeCharacter];
    [self setDesiredKanji:character];
}

- (KVGStroke *)desiredStroke
{
    return [self.desiredKanji strokeWithStrokeCount:[self desiredStrokeCount]];
}

- (NSInteger)desiredStrokeCount
{
    return self.nSuccessfulUserStrokes + 1;
}

- (void)setDesiredKanji:(KVGCharacter *)desiredKanji
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
