//
//  TUDouBanUserChannelRequest.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanUserChannelRequest.h"
#import "TUUserManager.h"

@interface TUDouBanUserChannelRequest ()

@property (nonatomic, copy) TUMusicLikeBlock block;

@end

// http://www.douban.com/j/app/radio/people

// 更新: https://api.douban.com/v2/fm/playlist?alt=json&apikey=02646d3fb69a52ff072d47bf23cef8fd&app_name=radio_iphone&channel=0&client=s%3Amobile%7Cy%3AiOS%2010.2%7Cf%3A115%7Cd%3Ab88146214e19b8a8244c9bc0e2789da68955234d%7Ce%3AiPhone7%2C1%7Cm%3Aappstore&douban_udid=b635779c65b816b13b330b68921c0f8edc049590&formats=aac&kbps=128&pt=4.6&sid=2093666&type=r&udid=b88146214e19b8a8244c9bc0e2789da68955234d&version=115

@implementation TUDouBanUserChannelRequest

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
    
    NSMutableDictionary *dict =  [NSMutableDictionary dictionaryWithDictionary:
                                  @{
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
                                    }];

    NSString *type = @"n";

    /**
     其中报告类型是以下的一种类型，都是一个字母。
     
     类型	需要参数	含义	报告长度
     b      sid     bye，不再播放，并放回一个新的歌曲列表	长报告
     e      sid     end，当前歌曲播放完毕，但是歌曲队列中还有歌曲	短报告
     n              new，没有歌曲播放，歌曲队列也没有任何歌曲，需要返回新播放列表	长报告
     p              playing，歌曲正在播放，队列中还有歌曲，需要返回新的播放列表	长报告
     s      sid     skip，歌曲正在播放，队列中还有歌曲，适用于用户点击下一首	短报告
     r      sid     rate，歌曲正在播放，标记喜欢当前歌曲	短报告
     u      sid     unrate，歌曲正在播放，标记取消喜欢当前歌曲	短报告
     */

    switch (self.type) {
        case TUDouBanRequestTypeLike:
            type = @"r";
            break;
        case TUDouBanRequestTypeUnLike:
            type = @"u";
            break;
        case TUDouBanRequestTypeSkip:
            type = @"s";
            break;
        case TUDouBanRequestTypePlayingList:
            type = @"p";
            break;
        case TUDouBanRequestTypeEnd:
            type = @"e";
            break;
        case TUDouBanRequestTypeBye:
            type = @"b";
            break;
        default:
            break;
    }
    
    [dict setObject:type forKey:@"type"];
    
    if (_sid.length) {
        [dict setObject:_sid forKey:@"sid"];
    }
    if (_channel_id) {
        [dict setObject:_channel_id forKey:@"channel"];
    }

    
    
    return dict;
    /**
     app_name	必选	string	radio_android	固定
     version	必选	int	100	固定
     
     user_id	非必选	string	user_id	若已登录，则填入
     expire     非必选	int	expire	若已登录，则填入
     token      非必选	string	token	若已登录，则填入
     
     sid        非必选	int	song id	在需要针对单曲操作时需要
     h          非必选	string	最近播放列表	单次报告曲目播放状态，其格式是 |sid:报告类型|sid:报告类型
     channel	非必选	int	频道id	获取频道时取得的channel_id
     type       必选	string	报告类型	需要调用的接口类型，也是使用下表的报告类型
     */
    
    /**
     其中报告类型是以下的一种类型，都是一个字母。
     
     类型	需要参数	含义	报告长度
     b      sid     bye，不再播放，并放回一个新的歌曲列表	长报告
     e      sid     end，当前歌曲播放完毕，但是歌曲队列中还有歌曲	短报告
     n              new，没有歌曲播放，歌曲队列也没有任何歌曲，需要返回新播放列表	长报告
     p              playing，歌曲正在播放，队列中还有歌曲，需要返回新的播放列表	长报告
     s      sid     skip，歌曲正在播放，队列中还有歌曲，适用于用户点击下一首	短报告
     r      sid     rate，歌曲正在播放，标记喜欢当前歌曲	短报告
     u      sid     unrate，歌曲正在播放，标记取消喜欢当前歌曲	短报告
     */
}

// 判断是否登录
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    if ([TUUserManager isDouBanLogin]) {
        //Authorization: Bearer d328fbe292431964797af3a7b6c94c2c
        return @{@"Authorization":[@"Bearer " stringByAppendingString:[TUUserManager sharedInstance].doubanUser.token]};
    }
    return @{};
}


- (BOOL)requestVerifyResult {
    NSNumber *r = self.responseObject[@"r"];
    return r.intValue == 0;
}

- (void)requestHandleResult {
//    NSLog(@"%s type:%lu respnse:%@", __func__, (unsigned long)_type,self.responseObject);
}

@end

/*
 {
 "r": 0,
 "version_max": 100,
 "song": [
 {
 "album": "/subject/5952615/",
 "picture": "http://img3.douban.com/mpic/s4616653.jpg",
 "ssid": "e1b2",
 "artist": "Bruno Mars / B.o.B",
 "url": "http://mr3.douban.com/201308250247/4a3de2e8016b5d659821ec76e6a2f35d/view/song/small/p1562725.mp3",
 "company": "EMI",
 "title": "Nothin' On You",
 "rating_avg": 4.04017,
 "length": 267,
 "subtype": "",
 "public_time": "2011",
 "sid": "1562725",
 "aid": "5952615",
 "sha256": "2422b6fa22611a7858060fd9c238e679626b3173bb0d161258b4175d69f17473",
 "kbps": "64",
 "albumtitle": "2011 Grammy Nominees",
 "like": 1
 },
 ...
 ]
 }
 */

