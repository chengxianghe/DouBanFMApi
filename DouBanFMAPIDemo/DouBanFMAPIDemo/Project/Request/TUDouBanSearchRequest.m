//
//  TUDouBanSearchRequest.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/25.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanSearchRequest.h"

// 搜索单曲
//https://api.douban.com/v2/fm/query/song?alt=json&apikey=02646d3fb69a52ff072d47bf23cef8fd&app_name=radio_iphone&client=s%3Amobile%7Cy%3AiOS%2010.2.1%7Cf%3A116%7Cd%3Ab88146214e19b8a8244c9bc0e2789da68955234d%7Ce%3AiPhone7%2C1%7Cm%3Aappstore&douban_udid=b635779c65b816b13b330b68921c0f8edc049590&limit=20&q=Rr&start=0&udid=b88146214e19b8a8244c9bc0e2789da68955234d&version=116


@implementation TUDouBanSearchRequest
- (TURequestCacheOption)cacheOption {
    return TURequestCacheOptionNone;
}

- (TURequestMethod)requestMethod {
    return TURequestMethodGet;
}

- (NSString *)requestUrl {
    return @"https://api.douban.com/v2/fm/query/song?";
}

- (NSDictionary *)requestParameters {
    /*
     limit=20&q=Rr&start=0
     */
    if (_searchText == nil) {
        _searchText = @"";
    }
    
    return @{@"start" : @(_page),
             @"q" : _searchText,
             @"limit" : @"20",
             
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

/**
 
 @property (nonatomic, copy) NSString *album;
 @property (nonatomic, copy) NSString *picture;
 @property (nonatomic, copy) NSString *ssid;
 @property (nonatomic, copy) NSString *artist;
 @property (nonatomic, copy) NSString *url;
 @property (nonatomic, copy) NSString *title;
 @property (nonatomic, copy) NSString *subtype;
 @property (nonatomic, copy) NSString *public_time;
 @property (nonatomic, copy) NSString *sid;
 @property (nonatomic, copy) NSString *aid;
 @property (nonatomic, copy) NSString *file_ext;
 @property (nonatomic, copy) NSString *sha256;
 @property (nonatomic, copy) NSString *kbps;
 @property (nonatomic, copy) NSString *albumtitle;
 @property (nonatomic, copy) NSString *alert_msg;
 
 @property (nonatomic, strong) NSNumber *status;
 @property (nonatomic, strong) NSNumber *length;
 @property (nonatomic, assign) BOOL like;
 
 @property (nonatomic, strong) NSArray *singers;
 @property (nonatomic, strong) UIImage *image;
 
 @property (nonatomic, assign) BOOL playable;

 {
    "items": [
        {
            "picture": "https://img3.doubanio.com/lpic/s1476941.jpg",
            "albumtitle": "潘朵拉",
            "artist_name": "张韶涵",
            "public_time": "2006",
            "id": "460894",
            "ssid": "d1b8",
            "title": "喜欢你没道理",
            "url": "",
            "artist": "张韶涵",
            "cover": "https://img3.doubanio.com/lpic/s1476941.jpg",
            "sid": "460894",
            "album_title": "潘朵拉",
            "playable": false,
            "channel": "2460894"
        },
        {
            "picture": "https://img3.doubanio.com/lpic/s6987806.jpg",
            "albumtitle": "你在烦恼什么",
            "artist_name": "苏打绿",
            "public_time": "2011",
            "id": "1741800",
            "ssid": "1f18",
            "title": "喜欢寂寞",
            "url": "",
            "artist": "苏打绿",
            "cover": "https://img3.doubanio.com/lpic/s6987806.jpg",
            "sid": "1741800",
            "album_title": "你在烦恼什么",
            "playable": false,
            "channel": "3741800"
        },
        {
            "picture": "https://img3.doubanio.com/lpic/s27068041.jpg",
            "albumtitle": "真的爱你",
            "artist_name": "Beyond",
            "public_time": "1998",
            "id": "554474",
            "ssid": "2748",
            "title": "喜欢你",
            "url": "http://mr7.doubanio.com/9915662e88f82f997cf8ca9b1f56131b/1/fm/song/p554474_128k.mp4",
            "artist": "Beyond",
            "cover": "https://img3.doubanio.com/lpic/s27068041.jpg",
            "sid": "554474",
            "album_title": "真的爱你",
            "playable": true,
            "channel": "2554474"
        },
        {
            "picture": "https://img1.doubanio.com/lpic/s4640428.jpg",
            "albumtitle": "百变张韶涵世界巡迴演唱会 台北场",
            "artist_name": "张韶涵",
            "public_time": "2007",
            "id": "1467638",
            "ssid": "9233",
            "title": "喜欢你没道理 (Live)",
            "url": "",
            "artist": "张韶涵",
            "cover": "https://img1.doubanio.com/lpic/s4640428.jpg",
            "sid": "1467638",
            "album_title": "百变张韶涵世界巡迴演唱会 台北场",
            "playable": false,
            "channel": "3467638"
        },
         {
         "picture": "http://img7.doubanio.com/lpic/s3941545.jpg",
         "albumtitle": "EGO",
         "artist_name": "백지영",
         "public_time": "2009",
         "id": "1484065",
         "ssid": "d962",
         "title": "내 귀에 캔디 (RRM’s Bitter Candy Mix)",
         "is_royal": false,
         "artist": "백지영",
         "cover": "http://img7.doubanio.com/lpic/s3941545.jpg",
         "url": "",
         "sid": "1484065",
         "album_title": "EGO",
         "playable": false,
         "channel": "3484065"
         }
         ],
    "total": 1225,
    "type": "song"
}

 */
