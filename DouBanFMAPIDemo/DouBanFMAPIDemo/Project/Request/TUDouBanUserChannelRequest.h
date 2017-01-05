//
//  TUDouBanUserChannelRequest.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <TUNetworking/TUNetworking.h>
#import <Foundation/Foundation.h>

@class TUDouBanUserChannelRequest;
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
 
 
 type是对该歌曲的操作，取值有：n/r/u/b/e。
 n:一开始进入豆瓣type取值为n
 s:下一曲
 r:对该歌曲加红心
 u:取消该歌曲的红心
 b:将该歌曲放入垃圾桶
 e:对该歌曲没有任何操作
 (若对歌曲无操作，不会更新歌曲列表，但是还会发送一个请求给豆瓣，类似于这种：http://douban.fm/j/mine/playlist?type=e&sid=2063541&channel=61&pt=286.9&pb=64&from=mainsite&r=aa555bfa8e，不过不会更新歌曲列表，该请求返回{"r":0})
 */
typedef NS_ENUM(NSUInteger, TUDouBanRequestType) {
    TUDouBanRequestTypeDefault = 0,
    TUDouBanRequestTypeNewList = TUDouBanRequestTypeDefault, // 需要channel
    TUDouBanRequestTypeLike, // 1
    TUDouBanRequestTypeUnLike, // 2
    TUDouBanRequestTypeSkip, // 3
    TUDouBanRequestTypePlayingList, // 4 需要
    TUDouBanRequestTypeEnd, // 5
    TUDouBanRequestTypeBye // 6
};

typedef void(^TUMusicLikeBlock)(TUDouBanUserChannelRequest *request, BOOL isSuccess);

@interface TUDouBanUserChannelRequest : TUBaseRequest

/** 非必选 channel 频道id	获取频道时取得的channel_id */
@property (nonatomic, copy) NSString *channel_id;
/** 非必选 song id	在需要针对单曲操作时需要 */
@property (nonatomic, copy) NSString *sid;

@property (nonatomic, assign) TUDouBanRequestType type;

@end
