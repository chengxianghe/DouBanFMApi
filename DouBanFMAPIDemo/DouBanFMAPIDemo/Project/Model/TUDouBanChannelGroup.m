//
//  TUDouBanChannelGroup.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 2017/1/4.
//  Copyright © 2017年 ITwU. All rights reserved.
//

#import "TUDouBanChannelGroup.h"
#import <MJExtension.h>

@implementation TUDouBanChannelGroup

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"chls" : [TUDouBanChannelModel class]};
}

@end
