//
//  DSNotePlayer.m
//  KEX
//
//  Created by Daniel Schlaug on 5/21/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "DSNotePlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface DSNotePlayer ()

@property (nonatomic,strong) NSMutableArray *audioPlayers;

@end

@implementation DSNotePlayer

- (void)playNote:(NSString *)note
{
    NSURL *noteURL = [[NSBundle mainBundle] URLForResource:note
                                             withExtension:@".m4a"
                                              subdirectory:@"Harp"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[noteURL path]], @"File for note %@ didn't exist at %@", note, [noteURL path]);
    NSError *err = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:noteURL error:&err];
    player.volume = .1;
    if (err != nil) {
        NSLog(@"%@", [err description]);
    }
    [player play];
    [self.audioPlayers addObject:player];
    player.delegate = self;
}

#pragma mark --Delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.audioPlayers removeObject:player];
}

#pragma mark --Accessor methods

- (NSArray *)audioPlayers
{
    if (!_audioPlayers) {
        _audioPlayers = [NSMutableArray array];
    }

return _audioPlayers;
}

@end
