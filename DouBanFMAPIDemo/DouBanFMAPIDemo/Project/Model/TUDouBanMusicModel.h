//
//  TUDouBanMusicModel.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TUDouBanMusicModel : NSObject

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
//@property (nonatomic, strong) NSNumber *channelId;

@property (nonatomic, assign) BOOL playable;


@end

@interface TUDouBanSingerModel : NSObject

@property (nonatomic, strong) NSNumber *related_site_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL is_site_artist;

@end

/*
 
 {
 "update_time": 1470126412,
 "playable": true,
 "like": 1,
 "sid": "1850372"
 }
 
 {
 "album": "/subject/2969122/",
 "status": 0,
 "picture": "http://img3.doubanio.com/lpic/s6682686.jpg",
 "ssid": "ce1a",
 "artist": "林宜融",
 "url": "http://mr7.doubanio.com/a518529dfb1c37dacfa22bd74ce23a28/0/fm/song/p179378_128k.mp4",
 "title": "同手同脚",
 "length": 252,
 "like": 0,
 "subtype": "",
 "public_time": "2008",
 "sid": "179378",
 "singers": [
    {
        "related_site_id": 0,
        "is_site_artist": false,
        "id": "35750",
        "name": "林宜融"
    }
 ],
 "aid": "2969122",
 "file_ext": "mp4",
 "sha256": "6aefaa6c0294b48348c34365a3a25ac6786962f25a20024b0e12210ab3533135",
 "kbps": "128",
 "albumtitle": "你们是我的星光",
 "alert_msg": ""
 }
 */

/*
{
    "albumtitle": "秒速5センチメートル オリジナルサウンドトラック",
    "url": "http://mr3.doubanio.com/9ffc03343b79a89009845c4df98b5f07/0/fm/song/p1391286_128k.mp4",
    "file_ext": "mp4",
    "album": "/subject/2170967/",
    "ssid": "0aab",
    "title": "END THEME",
    "sid": "1391286",
    "sha256": "c4eb3d5f8fb7054ab54dcbbdf7b0d2ce2c9947e466e4d2a2d05a77dbf560603f",
    "status": 0,
    "picture": "http://img3.doubanio.com/lpic/s2628567.jpg",
    "update_time": 1470126078,
    "alert_msg": "",
    "public_time": "2007",
    "singers": [
                {
                    "style": [],
                    "name": "天門",
                    "region": [
                               "日本"
                               ],
                    "name_usual": "天門",
                    "genre": [
                              "Pop",
                              "Soundtrack"
                              ],
                    "avatar": "https://img1.doubanio.com/img/fmadmin/large/32159.jpg",
                    "related_site_id": 0,
                    "is_site_artist": false,
                    "id": "39088"
                }
                ],
    "like": 0,
    "artist": "天門",
    "is_royal": false,
    "subtype": "",
    "length": 172,
    "release": {
        "link": "https://douban.fm/album/2170967g7f8c",
        "id": "2170967",
        "ssid": "7f8c"
    },
    "aid": "2170967",
    "kbps": "128"
}
*/
