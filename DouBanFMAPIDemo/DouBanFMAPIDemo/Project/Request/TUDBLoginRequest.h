//
//  TUDBLoginRequest.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 2017/1/4.
//  Copyright © 2017年 ITwU. All rights reserved.
//

#import <TUNetworking/TUNetworking.h>

@interface TUDBLoginRequest : TUBaseRequest
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@end
