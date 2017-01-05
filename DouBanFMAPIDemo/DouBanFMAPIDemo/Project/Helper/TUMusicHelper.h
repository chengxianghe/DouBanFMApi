//
//  TUMusicHelper.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/1.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TUMusicHelper : NSObject

+ (NSString *)stringWithCount:(NSInteger)count;

+ (NSString *)stringWithDuration:(NSInteger)stringWithDuration;

@end


@interface NSString (Blank)

- (NSString *)insertBlank;
- (NSString *)insertBlankWithNumber:(NSInteger)count;
- (NSString *)appendBlankWithNumber:(NSInteger)count;

@end
