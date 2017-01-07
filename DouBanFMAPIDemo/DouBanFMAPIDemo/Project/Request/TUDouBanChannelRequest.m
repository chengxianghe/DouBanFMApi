//
//  TUDouBanMusicRequest.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanChannelRequest.h"

//频道0歌曲数据网址
//http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite

// 更新 https://api.douban.com/v2/fm/playlist?channel=10&formats=aac&kbps=128&pt=0.0&type=n

@implementation TUDouBanChannelRequest

- (TURequestCacheOption)cacheOption {
    return TURequestCacheOptionNone;
}

- (TURequestMethod)requestMethod {
    return TURequestMethodGet;
}

- (NSString *)requestUrl {
    return @"https://api.douban.com/v2/fm/playlist";
}

- (NSDictionary *)requestParameters {
    if (_channel_id == nil) {
        _channel_id = @"0";
    }
    
    return @{@"type" : @"n",
             @"channel" : _channel_id,
             @"from" : @"mainsite",
             @"pt":@"0.0",
             @"kbps":@"128",
             @"formats":@"aac",
             
             @"alt":@"json",
             @"apikey":@"02646d3fb69a52ff072d47bf23cef8fd",
             @"app_name":@"radio_iphone",
             @"client":@"s:mobile|y:iOS 10.2|f:115|d:b88146214e19b8a8244c9bc0e2789da68955234d|e:iPhone7,1|m:appstore",
             @"douban_udid":@"b635779c65b816b13b330b68921c0f8edc049590",
             @"icon_cate":@"xlarge",
             @"udid":@"b88146214e19b8a8244c9bc0e2789da68955234d",
             @"version":@"115",
             };
}

- (void)requestHandleResult {
    NSLog(@"%s", __func__);
}

@end
