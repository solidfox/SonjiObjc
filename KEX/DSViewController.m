//
//  DSViewController.m
//  KEX
//
//  Created by Daniel Schlaug on 2/20/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "DSViewController.h"
#import "KVGCharacter+Creation.h"
#import "DSCharacterCanvas.h"
#import "CMUnistrokeGestureRecognizer.h"
#import "KVGFetcher.h"


@interface DSViewController ()

@property (weak, nonatomic) IBOutlet DSCharacterCanvas *kanjiCanvas;
@property (strong, nonatomic) KVGFetcher *characterRepo;

@end

@implementation DSViewController

- (KVGFetcher *)characterRepo
{
    if (!_characterRepo) {
        _characterRepo = [[KVGFetcher alloc] init];
    }
    return _characterRepo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    KVGCharacter *character = [self.characterRepo characterFor:[@"選" characterAtIndex:0]];
    
    //self.kanjiView.inputCharacterDimensions = character.dimensions;
    
    for (KVGStroke *stroke in [character strokes]) {
        [self.kanjiCanvas addStroke:stroke.path];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
