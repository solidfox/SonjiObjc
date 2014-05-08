//
//  DSStrokeSonifier.m
//  KEX
//
//  Created by Daniel Schlaug on 4/16/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "DSStrokeSonifier.h"
#import "PdAudioController.h"
#import "PdDispatcher.h"
#import "PdBase.h"

@interface DSStrokeSonifier ()

@property (strong, nonatomic) PdAudioController *audioController;
@property (strong, nonatomic) PdDispatcher *dispatcher;
@property (nonatomic) void *patch;

@end

@implementation DSStrokeSonifier

- (id)init
{
    self = [super init];
    self.patch = [PdBase openFile:@"pitchedNoise.pd"
                             path:[[NSBundle mainBundle] resourcePath]];
    self.dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:self.dispatcher];
    if (!self.patch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }
    
    self.audioController.active = YES;
    
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

- (void)setCurrentPosition:(CGPoint)currentPosition
{
    [PdBase sendFloat:currentPosition.x toReceiver:@"noisePitch"];
    [PdBase sendBangToReceiver:@"turnOn"];
}

- (void)turnOff
{
    [PdBase sendBangToReceiver:@"turnOff"];
}

@end
