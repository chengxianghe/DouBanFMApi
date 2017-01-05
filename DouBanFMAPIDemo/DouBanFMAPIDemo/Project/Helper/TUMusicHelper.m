//
//  TUMusicHelper.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/1.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUMusicHelper.h"

@implementation TUMusicHelper

+ (NSString *)stringWithCount:(NSInteger)count {
    if (count <= 0) {
        return @"0";
    } else if (count < 10000) {
        return @(count).stringValue;
    } else if (count < 100000000) {
        return [NSString stringWithFormat:@"%.1f万", count/10000.0];
    } else {
        return [NSString stringWithFormat:@"%.1f亿", count/100000000.0];
    }
}

+ (NSString *)stringWithDuration:(NSInteger)duration {
    // 获取小时
    NSInteger hour = duration / 3600;
    // 获取分钟
    NSInteger min = (duration % 3600) / 60;
    // 获取秒数
    NSInteger sec = duration % 60;
    
    if (hour) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)min, (long)sec];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
    }
    
}

@end

@implementation NSString (Blank)

- (NSString *)insertBlank {
    return [NSString stringWithFormat:@" %@", self];
}

- (NSString *)insertBlankWithNumber:(NSInteger)count {
    return [NSString stringWithFormat:@"%@%@", [self blankStringWithNumber:count], self];
}

- (NSString *)appendBlankWithNumber:(NSInteger)count {
    return [NSString stringWithFormat:@"%@%@", self, [self blankStringWithNumber:count]];
}

- (NSString *)blankStringWithNumber:(NSInteger)count {
    NSMutableString *string = [NSMutableString stringWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        [string appendString:@" "];
    }
    return string;
}

@end
