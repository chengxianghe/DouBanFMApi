//
//  TUDouBanUserModel.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUDouBanUserModel : NSObject

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *expire;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *refresh_token;

@end

/*
 {
 "access_token" = 21a0867e86f16fb464e1937b94d44f1c;
 "douban_user_id" = 145626941;
 "douban_user_name" = "\U4e91\U9038";
 "expires_in" = 7775999;
 "refresh_token" = 77bc1538a652d3b867343fa9f2f87b28;
 }
 */
