//
//  TUDouBanChannelModel.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUDouBanChannelStyle : NSObject

@property (nonatomic, copy) NSString *bg_color;
@property (nonatomic, copy) NSString *layout_type;
@property (nonatomic, copy) NSString *bg_image;
@property (nonatomic, copy) NSString *display_text;

@end

@interface TUDouBanChannelSong : NSObject

@property (nonatomic, copy) NSString *song_id;
@property (nonatomic, copy) NSString *ssid;

@end

@interface TUDouBanChannelRelation : NSObject

@property (nonatomic, strong) TUDouBanChannelSong *song;

@end

@interface TUDouBanChannelModel : NSObject

@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *collected;
@property (nonatomic, assign) NSInteger channel_type;
@property (nonatomic, assign) NSInteger song_num;
@property (nonatomic, strong) TUDouBanChannelStyle *style;
@property (nonatomic, strong) TUDouBanChannelRelation *channel_relation;

@end


/*
{
    "style": {
        "bg_color": "0xe06b59",
        "layout_type": 2,
        "bg_image": ""
    },
    "intro": "豆瓣好评音乐精选",
    "name": "豆瓣精选",
    "collected": "disabled",
    "cover": "https://img3.doubanio.com/f/fm/c1f6362114965225752341e9291a4b2f39f78cfb/pics/fm/channel_selected_cover.png",
    "id": -10
    "channel_type": 0,
    "song_num": 1189,
    "artist": "Cat Stevens",
    "channel_relation": {
        "song": {
            "id": "348914",
            "ssid": "23c5"
        }
    },
    "start": "348914g23c5g2348914",
 
}
 */
