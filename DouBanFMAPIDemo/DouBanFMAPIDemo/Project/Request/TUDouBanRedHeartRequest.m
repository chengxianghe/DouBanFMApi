//
//  TUDouBanRedHeartRequest.m
//  DouBanFMAPIDemo
//
//  Created by chengxianghe on 2017/1/5.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "TUDouBanRedHeartRequest.h"
#import "TUUserManager.h"

//https://api.douban.com/v2/fm/songs
// 需要登录

@implementation TUDouBanRedHeartRequest

- (TURequestMethod)requestMethod {
    return TURequestMethodPost;
}

- (NSString *)requestUrl {
    return @"https://api.douban.com/v2/fm/songs";
}

- (NSDictionary<NSString *,id> *)requestParameters {
    /*
     sids=1850372|631686|575943|1382934|1495608|1818705|383647|1839119|2093666|1940892|2235174|2602648|1772481|680412|424940|723297|1456230|1918705|1876452|1829079|471520|1895161|1700409|191731|1995017|10179|1808097|1493283|1488308|150725|393489|647021|1905883|1483331|356633|749764|27826|1846295|1387815|1838403|1456769|677879|409998|1879867|1700983|451509|1894653|499234|1894342|1635044|187526
     */
    return @{
             @"kbps":@"128",
             @"alt":@"json",
             @"apikey":@"02646d3fb69a52ff072d47bf23cef8fd",
             @"app_name":@"radio_iphone",
             @"client":@"s:mobile|y:iOS 10.2|f:115|d:b88146214e19b8a8244c9bc0e2789da68955234d|e:iPhone7,1|m:appstore",
             @"douban_udid":@"b635779c65b816b13b330b68921c0f8edc049590",
             @"udid":@"b88146214e19b8a8244c9bc0e2789da68955234d",
             @"version":@"115",
             @"sids":[_sids componentsJoinedByString:@"|"],
             };
}

// 判断是否登录
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    if ([TUUserManager isDouBanLogin]) {
        return @{@"Authorization":[@"Bearer " stringByAppendingString:[TUUserManager sharedInstance].doubanUser.token]};
    }
    return @{};
}

- (void)requestHandleResult {
    //    NSLog(@"%s type:%lu respnse:%@", __func__, (unsigned long)_type,self.responseObject);
}

@end

@implementation TUDouBanRedHeartSidsRequest

- (TURequestMethod)requestMethod {
    return TURequestMethodGet;
}

- (NSString *)requestUrl {
    return @"https://api.douban.com/v2/fm/redheart/basic";
}

- (NSDictionary<NSString *,id> *)requestParameters {
    /*
     https://api.douban.com/v2/fm/redheart/basic?alt=json&apikey=02646d3fb69a52ff072d47bf23cef8fd&app_name=radio_iphone&client=s%3Amobile%7Cy%3AiOS%2010.2%7Cf%3A115%7Cd%3Ab88146214e19b8a8244c9bc0e2789da68955234d%7Ce%3AiPhone7%2C1%7Cm%3Aappstore&douban_udid=b635779c65b816b13b330b68921c0f8edc049590&kbps=128&udid=b88146214e19b8a8244c9bc0e2789da68955234d&version=115
     */
    return @{
             @"kbps":@"128",
             @"alt":@"json",
             @"apikey":@"02646d3fb69a52ff072d47bf23cef8fd",
             @"app_name":@"radio_iphone",
             @"client":@"s:mobile|y:iOS 10.2|f:115|d:b88146214e19b8a8244c9bc0e2789da68955234d|e:iPhone7,1|m:appstore",
             @"douban_udid":@"b635779c65b816b13b330b68921c0f8edc049590",
             @"udid":@"b88146214e19b8a8244c9bc0e2789da68955234d",
             @"version":@"115",
             };
}

// 判断是否登录
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    if ([TUUserManager isDouBanLogin]) {
        return @{@"Authorization":[@"Bearer " stringByAppendingString:[TUUserManager sharedInstance].doubanUser.token]};
    }
    return @{};
}

- (void)requestHandleResult {
    
}

@end

/*
 
 //https://api.douban.com/v2/fm/redheart/basic?
{
    "description": "",
    "collected_count": 0,
    "creator": {
        "url": "https:\/\/www.douban.com\/people\/chengxianghe\/",
        "picture": "http://img7.doubanio.com\/icon\/u145626941-1.jpg",
        "id": "145626941",
        "name": "云逸"
    },
    "offshelf_alert": "部分红心歌曲版权洽谈中，暂时不能收听，等待它们浮出海面的同时，去收获更多新的红心吧",
    "title": "我的红心歌曲",
    "cover": "",
    "updated_time": "2017-01-05 16:06:48",
    "is_collected": true,
    "rec_reason": "",
    "created_time": "",
    "can_play": true,
    "type": -1,
    "id": -1,
    "songs": [{
        "update_time": 1470126412,
        "playable": true,
        "like": 1,
        "sid": "1850372"
    }, {
        "update_time": 1470125995,
        "playable": true,
        "like": 1,
        "sid": "631686"
    }, {
        "update_time": 1470125956,
        "playable": true,
        "like": 1,
        "sid": "575943"
    }, {
        "update_time": 1470126322,
        "playable": true,
        "like": 1,
        "sid": "1635044"
    }, {
        "update_time": 1475994036,
        "playable": false,
        "like": 1,
        "sid": "187526"
    }]
}
*/
