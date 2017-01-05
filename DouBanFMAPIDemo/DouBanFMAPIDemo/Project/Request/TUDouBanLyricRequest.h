//
//  TUDouBanLyricRequest.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <TUNetworking/TUNetworking.h>

@interface TUDouBanLyricRequest : TUBaseRequest

//sid	是	string	歌曲的sid
@property (nonatomic, copy) NSString *sid;
//ssid	是	string	歌曲的ssid
@property (nonatomic, copy) NSString *ssid;

@end
