//
//  DSNotePlayer.h
//  KEX
//
//  Created by Daniel Schlaug on 5/21/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface DSNotePlayer : NSObject <AVAudioPlayerDelegate>

- (void)playNote:(NSString *)note;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

@end