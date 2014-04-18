//
//  KVGRepository.m
//
//  Created by Daniel Schlaug on 3/11/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

#import "KVGRepository.h"

@implementation KVGRepository

+ (NSString *)repositoryURLFor:(unichar)unicodeCharacter
{
    NSString *characterFilename = [NSString stringWithFormat:@"%x", unicodeCharacter];
    int prefixZeroes = 5-[characterFilename length];
    NSString *prefix = [@"" stringByPaddingToLength:prefixZeroes withString:@"0" startingAtIndex:0];
    characterFilename = [prefix stringByAppendingFormat:@"%@.svg", characterFilename];
    return [@"https://raw.github.com/KanjiVG/kanjivg/master/kanji/" stringByAppendingString:characterFilename];
}

+ (NSData *)characterDataFor:(unichar)unicodeCharacter
{
    NSURL *characterURL = [NSURL URLWithString:[KVGRepository repositoryURLFor:unicodeCharacter]];
    NSData *SVGData = [NSData dataWithContentsOfURL:characterURL];
    return SVGData;
}

@end
