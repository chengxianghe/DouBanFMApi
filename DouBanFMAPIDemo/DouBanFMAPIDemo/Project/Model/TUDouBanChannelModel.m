//
//  TUDouBanChannelModel.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanChannelModel.h"
#import <MJExtension.h>

@implementation TUDouBanChannelStyle

@end

@implementation TUDouBanChannelSong

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"song_id":@"id"};
}

@end

@implementation TUDouBanChannelRelation

@end

@implementation TUDouBanChannelModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"channel_id":@"id"};
}

@end
