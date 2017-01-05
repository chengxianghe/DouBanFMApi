//
//  TUDouBanSearchRequest.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/25.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanSearchRequest.h"

//  NSString *URL = [NSString stringWithFormat:@"http://api.douban.com/music/subjects?q=321&max-results=30&apikey=058a7fc77af5da75109f7f5670e18f5f",parameter];
// XML

@implementation TUDouBanSearchRequest
- (TURequestCacheOption)cacheOption {
    return TURequestCacheOptionNone;
}

- (TURequestMethod)requestMethod {
    return TURequestMethodGet;
}

- (NSString *)requestUrl {
    return @"https://douban.fm/j/v2/query/song?";
}

- (NSDictionary *)requestParameters {
    //q=1&start=0&limit=5

    if (_searchText == nil) {
        _searchText = @"";
    }
    return @{
             @"start" : @"0",
             @"q" : _searchText,
             @"limit" : @"5",
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
            "picture": "https://img1.doubanio.com/lpic/s3124228.jpg",
            "albumtitle": "08拉阔第一场",
            "artist_name": "陈奕迅 / 方大同",
            "public_time": "2008",
            "id": "1466612",
            "ssid": "a171",
            "title": "喜欢你",
            "url": "",
            "artist": "陈奕迅 / 方大同",
            "cover": "https://img1.doubanio.com/lpic/s3124228.jpg",
            "sid": "1466612",
            "album_title": "08拉阔第一场",
            "playable": false,
            "channel": "3466612"
        }
    ],
    "total": 1225,
    "type": "song"
}

 */
