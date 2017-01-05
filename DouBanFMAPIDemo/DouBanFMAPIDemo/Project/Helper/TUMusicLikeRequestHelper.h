//
//  TUMusicLikeRequestHelper.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/1.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUDouBanUserChannelRequest.h"

@interface TUMusicLikeRequestHelper : NSObject

+ (void)likeMusicWithSid:(NSString *)sid
               channelId:(NSString *)channelId
                isToLike:(BOOL)isToLike
              completion:(TUMusicLikeBlock)completion;

@end
