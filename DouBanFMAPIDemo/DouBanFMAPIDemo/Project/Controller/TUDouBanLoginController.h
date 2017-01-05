//
//  TUDouBanLoginControllerViewController.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TUDouBanLoginBlock)();

@interface TUDouBanLoginController : UIViewController

+ (instancetype)loginControllerWithSuccess:(TUDouBanLoginBlock)success cancel:(TUDouBanLoginBlock)cancel;

@end
