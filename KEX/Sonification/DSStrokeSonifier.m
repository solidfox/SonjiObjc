//
//  DSStrokeSonifier.m
//  KEX
//
//  Created by Daniel Schlaug on 4/16/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "DSStrokeSonifier.h"
#import "PdAudioController.h"
#import "PdBase.h"

@interface DSStrokeSonifier ()

@property (strong, nonatomic)PdAudioController *audioController;
@property (nonatomic)void *patch;

@end

@implementation DSStrokeSonifier

- (id)init
{
    self = [super init];
    self.patch = [PdBase openFile:@"pitchedNoise.pd"
                             path:[[NSBundle mainBundle] resourcePath]];
    if (!self.patch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }
    return self;
}

- (PdAudioController *)audioController
{
    if (!_audioController) {
        _audioController = [[PdAudioController alloc] init];
        if ([self.audioController configureAmbientWithSampleRate:44100
                                                  numberChannels:2 mixingEnabled:YES]
            != PdAudioOK) {
            NSLog(@"failed to initialize audio components");
        }
    }
    return _audioController;
}

@end
