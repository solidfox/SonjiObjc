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
#import "DSNotePlayer.h"

@interface DSStrokeSonifier ()

@property (strong, nonatomic) PdAudioController *audioController;
@property (strong, nonatomic) PdDispatcher *dispatcher;
@property (nonatomic) void *patch;
@property (nonatomic) CGPoint lastPosition;
@property (nonatomic, readonly) NSArray *horizontalNotes;
@property (nonatomic, readonly) DSNotePlayer *notePlayer;

@end

@implementation DSStrokeSonifier

@synthesize notePlayer = _notePlayer;
@synthesize horizontalNotes = _horizontalNotes;

- (id)initWithFrame:(CGRect)frame
{
    self.lastPosition = CGPointMake(-1, -1);
    self = [super init];
    self.bounds = frame;
    self.audioController.active = YES;
    self.dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:self.dispatcher];
    
    self.patch = [PdBase openFile:@"pitchedNoise.pd"
                             path:[[NSBundle mainBundle] resourcePath]];
    if (!self.patch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }
    [PdBase sendFloat:0.4 toReceiver:@"noiseWidth"];
    [PdBase sendFloat:110 toReceiver:@"attack"];
    [PdBase sendFloat:200 toReceiver:@"release"];
    [PdBase sendFloat:0.04 toReceiver:@"masterVolume"];
    
    
    
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
    [self setBrusOptionsForPosition:currentPosition];
    [self playNotesForPosition:currentPosition];
    self.lastPosition = currentPosition;
}

- (void)setCurrentVelocity:(CGPoint)currentVelocity
{
    CGFloat combinedVelocity = sqrt(currentVelocity.x * currentVelocity.x + currentVelocity.y * currentVelocity.y);
    CGFloat volume = MIN(1, log(combinedVelocity/2)/log(700));
    [PdBase sendFloat:volume toReceiver:@"volume"];
}

- (void)turnOn
{
    [PdBase sendBangToReceiver:@"turnOn"];
}

- (void)turnOff
{
    [PdBase sendBangToReceiver:@"turnOff"];
    self.lastPosition = CGPointMake(-1, -1);
}

#pragma mark --Private methods

- (void)setBrusOptionsForPosition:(CGPoint)currentPosition
{
    CGFloat normalizedX = currentPosition.x/self.bounds.size.width;
    CGFloat midiMin = 83;
    CGFloat midiMax = 89;
    
    CGFloat midiNote = midiMin + (midiMax - midiMin) * normalizedX;
    
    NSAssert(self.audioController.active == YES, @"Audio controller was not active.");
    
    [PdBase sendFloat:midiNote toReceiver:@"noisePitch"];
}

- (void)playNotesForPosition:(CGPoint)currentPosition
{
    if (self.lastPosition.x != -1) {
        NSUInteger nNotes = [self.horizontalNotes count];
        for (NSString *note in self.horizontalNotes) {
            NSUInteger i = [self.horizontalNotes indexOfObject:note];
            CGFloat notePosition = self.bounds.size.width/(nNotes+1) * (i+1);
            if (notePosition >= MIN(currentPosition.x, self.lastPosition.x) &&
                notePosition < MAX(currentPosition.x, self.lastPosition.x)) {
                NSLog(@"Playing note: %@", note);
                [self.notePlayer playNote:note];
            }
        }
    }
}

#pragma mark Accessor methods

- (NSArray *)horizontalNotes
{
    if (!_horizontalNotes) {
        _horizontalNotes = @[@"F5",@"A#5",@"C6",@"F6"];
    }
    return _horizontalNotes;
}

- (DSNotePlayer *)notePlayer
{
    if (!_notePlayer) {
        _notePlayer = [[DSNotePlayer alloc] init];
    }
    return _notePlayer;
}

@end
