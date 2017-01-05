//
//  MusicIndicator.m
//  Ting
//
//  Created by Aufree on 11/18/15.
//  Copyright © 2015 Ting. All rights reserved.
//

#import "MusicIndicator.h"

@implementation MusicIndicator

+ (instancetype)sharedInstance {
    static MusicIndicator *_sharedMusicIndicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMusicIndicator = [[MusicIndicator alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _sharedMusicIndicator.hidesWhenStopped = NO;
        _sharedMusicIndicator.tintColor = [UIColor redColor];
    });

    return _sharedMusicIndicator;
}

@end
