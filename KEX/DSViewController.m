//
//  DSViewController.m
//  KEX
//
//  Created by Daniel Schlaug on 2/20/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "DSViewController.h"
#import "KVGCharacter.h"
#import "DSCharacterCanvas.h"
#import "CMUnistrokeGestureRecognizer.h"
#import "KVGRepository.h"
#import "DSStrokeSonifier.h"


@interface DSViewController ()

@property (weak, nonatomic) IBOutlet DSCharacterCanvas *kanjiCanvas;
@property (weak, nonatomic) IBOutlet UITextField *kanjiTextField;
@property (weak, nonatomic) IBOutlet UISlider *strokesSlider;

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    DSStrokeSonifier *sonifier = [[DSStrokeSonifier alloc] init];
    
    NSData * characterData = [KVGRepository downloadCharacterDataFor:[@"選" characterAtIndex:0]];
    KVGCharacter *character = [KVGCharacter characterFromSVGData:characterData];
    
    //self.kanjiView.inputCharacterDimensions = character.dimensions;
    
    for (KVGStroke *stroke in [character strokes]) {
        [self.kanjiCanvas addStroke:stroke.path];
    }
    
    self.strokesSlider.maximumValue = [character.strokes count];
    self.strokesSlider.value = self.strokesSlider.maximumValue;
    
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

@end
