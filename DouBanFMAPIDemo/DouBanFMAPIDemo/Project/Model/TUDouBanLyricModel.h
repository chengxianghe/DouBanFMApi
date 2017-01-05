//
//  TUDouBanLyricModel.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUDouBanLyricModel : NSObject

@property (nonatomic, copy) NSString *lyric;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sid;

@end

/** 豆瓣的
 {
 "lyric": "歌词正文",
 "name": "歌名",
 "sid": "sid"
 }
 */

/*
 {
 "aid": 2848529,
 "lrc": "http://s.geci.me/lrc/344/34435/3443588.lrc",
 "song": "海阔天空",
 "artist_id": 2,
 "sid": 3443588
 }

 歌词
 [ti: 海阔天空]
 [ar:黄家驹]
 [al:乐与怒]
 [by:mp3.50004.com]
 [00:00.00]Beyond：海阔天空
 [01:40.00][00:16.00]今天我寒夜里看雪飘过
 [01:48.00][00:24.00]怀著冷却了的心窝飘远方
 [01:53.00][00:29.00]风雨里追赶
 [01:57.00][00:33.00]雾里分不清影踪
 [02:00.00][00:36.00]天空海阔你与我
 [02:03.00][00:39.00]可会变(谁没在变)
 
 [00:42.00]多少次迎著冷眼与嘲笑
 [00:49.00]从没有放弃过心中的理想
 [00:54.00]一刹那恍惚
 [00:58.00]若有所失的感觉
 [01:01.00]不知不觉已变淡
 [01:04.00]心里爱(谁明白我)
 
 [03:56.00][03:18.00][02:06.00][01:07.00]原谅我这一生不羁放纵爱自由
 [04:01.00][03:24.00][02:12.00][01:13.00]也会怕有一天会跌倒
 [04:06.00][03:44.00][03:29.00][02:19.00][01:20.00]被弃了理想谁人都可以
 [04:14.00][03:49.00][03:37.00][02:26.00][01:26.00]那会怕有一天只你共我
 
 [03:05.00]仍然自由自我
 [03:10.00]永远高唱我歌
 [03:13.00]走遍千里
 
 http://lrc.bzmtv.com
 
 
 */

