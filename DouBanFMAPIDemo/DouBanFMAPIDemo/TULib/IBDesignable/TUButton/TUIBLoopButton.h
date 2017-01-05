//
//  TUIBLoopButton.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/17.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TULoopButtonState) {
    /** 单曲循环 */
    TULoopButtonStateOne = 0,
    /** 列表循环 */
    TULoopButtonStateAll,
    /** 随机循环 */
    TULoopButtonStateShuffle,
    TULoopButtonStateMax = TULoopButtonStateShuffle,
};

IB_DESIGNABLE//声明类是可设计的
@interface TUIBLoopButton : UIButton

/** 单曲循环 */
@property(nonatomic)IBInspectable UIImage *loopOneImage;
@property(nonatomic)IBInspectable UIImage *loopOneHighlightImage;

/** 列表循环 */
@property(nonatomic)IBInspectable UIImage *loopAllImage;
@property(nonatomic)IBInspectable UIImage *loopAllHighlightImage;

/** 随机循环 */
@property(nonatomic)IBInspectable UIImage *loopShuffleImage;
@property(nonatomic)IBInspectable UIImage *loopShuffleHighlightImage;

/** 设置image or backgroundImage */
@property(nonatomic)IBInspectable BOOL isBackground;

/** 设置state 0-2 */
@property(nonatomic)IBInspectable NSUInteger loopState;

@end
