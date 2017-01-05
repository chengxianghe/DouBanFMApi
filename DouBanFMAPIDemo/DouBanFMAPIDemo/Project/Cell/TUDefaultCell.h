//
//  TUDefaultCell.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TUDouBanMusicModel;
@interface TUDefaultCell : UITableViewCell

+ (CGFloat)height;

- (void)setInfo:(TUDouBanMusicModel *)info;

@end
