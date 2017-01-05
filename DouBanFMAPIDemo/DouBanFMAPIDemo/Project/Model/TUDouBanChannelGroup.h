//
//  TUDouBanChannelGroup.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 2017/1/4.
//  Copyright © 2017年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUDouBanChannelModel.h"

@interface TUDouBanChannelGroup : NSObject

@property (nonatomic, strong) NSArray *chls;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *group_name;

@end
/*
{
    "chls": [
             {
                 "style": {
                     "display_text": "",
                     "bg_color": "0x499884",
                     "layout_type": 1,
                     "bg_image": ""
                 },
                 "intro": "我的个性化音乐频道",
                 "name": "我的私人",
                 "song_num": 0,
                 "collected": "disabled",
                 "cover": "https://img3.doubanio.com/f/fm/11bed977076d721fb66ef6c2f2cfb66ae79ed07a/pics/fm/default_personal_channel_cover.png",
                 "id": 0
             },
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
             }
             ],
    "group_id": 0,
    "group_name": ""
}
*/
