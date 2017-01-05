//
//  TUDouBanChannelController.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUViewController.h"

@class TUDouBanChannelModel, TUDouBanUserModel;

@interface TUDouBanChannelController : TUViewController

@property (strong, nonatomic) TUDouBanChannelModel *channel;
@property (assign, nonatomic) BOOL isRedHeart;

+ (instancetype)channelControllerWithChannel:(TUDouBanChannelModel *)channel;

@end
