//
//  TUDouBanSearchRequest.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/25.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <TUNetworking/TUNetworking.h>

@interface TUDouBanSearchRequest : TUBaseRequest

@property (nonatomic, copy) NSString *searchText;
@property (assign, nonatomic) NSInteger page;

@end
