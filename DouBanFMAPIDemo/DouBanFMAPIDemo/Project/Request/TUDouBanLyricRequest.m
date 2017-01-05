//
//  TUDouBanLyricRequest.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanLyricRequest.h"

// 豆瓣的 http://api.douban.com/v2/fm/lyric
// https://api.douban.com/v2/fm/lyric?sid=2197343&ssid=5b5b
@implementation TUDouBanLyricRequest

- (TURequestCacheOption)cacheOption {
    return TURequestCacheOptionCacheSaveFlow;
}

- (NSString *)requestUrl {
    return @"https://api.douban.com/v2/fm/lyric";
}

- (NSDictionary *)requestParameters {
    if (_sid == nil) {
        _sid = @"";
    }
    if (_ssid == nil) {
        _ssid = @"";
    }
    return @{@"sid" : _sid, @"ssid" : _ssid};
}

- (void)requestHandleResult {
    NSLog(@"%s", __func__);
}

@end

/** 豆瓣的
 URL: http://api.douban.com/v2/fm/lyric
 
 Method: POST
 
 Arguments:
 
 参数名	是否必选	参数类型	值	备注
 sid	是	int	歌曲的sid
 ssid	是	string	歌曲的ssid
 Response (application/json):
 {
 "lyric": "歌词正文",
 "name": "歌名",
 "sid": "sid"
 }
 */

/*
 歌词正文：
 [03:18.61][02:06.84][00:40.77]弯弯月光下 蒲公英在游荡
 [03:22.67][02:10.87][00:44.66]像烟花闪着微亮的光芒
 [03:26.64][02:14.91][00:48.81]趁着夜晚 找寻幸福方向
 [03:31.82][02:19.92][00:54.15]难免会受伤
 [02:23.14][00:57.00]弯弯小路上 蒲公英在歌唱
 [02:27.26][01:01.11]星星照亮在起风的地方
 [02:31.33][01:05.20]乘着微风 飘向未知远方
 [02:36.07][01:09.94]幸福路也许漫长
 [02:41.39][01:15.32]难过的时候 谁在身边
 [02:45.37][01:19.32]陪我掉眼泪
 [02:49.61][01:23.45]失败无所谓 你在左右
 [02:53.19][01:26.97]月光多美
 [03:35.05][02:56.17][01:30.05][00:01.35]弯弯月光下 我轻轻在歌唱
 [03:39.09][03:00.06][01:33.95][00:05.94]从今以后 不会再悲伤
 [03:43.21][03:04.23][01:38.06][00:10.60]闭上双眼 感觉你在身旁
 [03:47.97][03:09.01][01:42.85]你是温暖月光 你是幸福月光
 [00:16.27]你是温暖月光
 [03:56.47][01:51.44][00:22.14]
 [03:56.47][01:51.44][00:22.14]
 */

/*
 // 第三方歌词搜索 http://geci.me/api/lyric/海阔天空
 {
 "count": 15,
 "code": 0, 
 "result": [
 {"aid": 2848529, "lrc": "http://s.geci.me/lrc/344/34435/3443588.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 2, "sid": 3443588}, 
 {"aid": 2346662, "lrc": "http://s.geci.me/lrc/274/27442/2744281.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 2396, "sid": 2744281}, 
 {"aid": 1889264, "lrc": "http://s.geci.me/lrc/210/21070/2107014.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 8715, "sid": 2107014}, 
 {"aid": 2075717, "lrc": "http://s.geci.me/lrc/236/23651/2365157.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 8715, "sid": 2365157}, 
 {"aid": 1563419, "lrc": "http://s.geci.me/lrc/166/16685/1668536.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 1668536}, 
 {"aid": 1567586, "lrc": "http://s.geci.me/lrc/167/16739/1673997.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 1673997}, 
 {"aid": 1571906, "lrc": "http://s.geci.me/lrc/167/16796/1679605.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 1679605}, 
 {"aid": 1573814, "lrc": "http://s.geci.me/lrc/168/16819/1681961.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 1681961}, 
 {"aid": 1656038, "lrc": "http://s.geci.me/lrc/179/17907/1790768.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 1790768}, 
 {"aid": 1718741, "lrc": "http://s.geci.me/lrc/187/18757/1875769.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 1875769}, 
 {"aid": 2003267, "lrc": "http://s.geci.me/lrc/226/22642/2264296.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 2264296}, 
 {"aid": 2020610, "lrc": "http://s.geci.me/lrc/228/22889/2288967.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 2288967}, 
 {"aid": 2051678, "lrc": "http://s.geci.me/lrc/233/23323/2332322.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 2332322}, 
 {"aid": 2412704, "lrc": "http://s.geci.me/lrc/283/28376/2837689.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 2837689}, 
 {"aid": 2607041, "lrc": "http://s.geci.me/lrc/311/31116/3111659.lrc", "song": "\u6d77\u9614\u5929\u7a7a", "artist_id": 9208, "sid": 3111659}
 ]
 }
 */
