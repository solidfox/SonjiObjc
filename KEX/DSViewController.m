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
#import "CMUnistrokeGestureRecognizer.h"
#import "KVGRepository.h"
#import "DSStrokeSonifier.h"


@interface DSViewController ()

@property (weak, nonatomic) IBOutlet DSCharacterView *kanjiCanvas;
@property (weak, nonatomic) IBOutlet UITextField *kanjiTextField;
@property (weak, nonatomic) IBOutlet UISlider *strokesSlider;
@property (strong, nonatomic) KVGRepository *kanjiRepo;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *kanjiButtons;

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    DSStrokeSonifier *sonifier = [[DSStrokeSonifier alloc] init];
    
    self.kanjiRepo = [[KVGRepository alloc] initWithDefaultLocalCacheURL];
    
    for (UIButton *button in self.kanjiButtons) {
        unichar character = [[button titleForState:UIControlStateNormal] characterAtIndex:0];
        [self.kanjiRepo loadCharacterDataFor:character completionHandler:^(BOOL success){}];
    }
    
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)strokeSliderChanged:(UISlider *)sender {
    self.kanjiCanvas.shownStrokes = sender.value;
}

- (IBAction)kanjiButtonPushed:(UIButton *)sender {
    [self setShownKanji:[[sender titleForState:UIControlStateNormal] characterAtIndex:0]];
}

- (void)setShownKanji:(unichar)unicodeCharacter
{
    KVGCharacter *character = [self.kanjiRepo KVGCharacterFor:unicodeCharacter];
    
    [self.kanjiCanvas removeStrokes];
    for (KVGStroke *stroke in [character strokes]) {
        [self.kanjiCanvas addStroke:stroke.path];
    }
    
    self.strokesSlider.maximumValue = [character.strokes count];
    self.strokesSlider.value = self.strokesSlider.maximumValue;
}

@end
