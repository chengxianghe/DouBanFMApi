//
//  TUUIMacro.h
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#ifndef TUUIMacro_h
#define TUUIMacro_h

// 屏幕大小
#define kScreenSize     [[UIScreen mainScreen] bounds].size

#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define kScreenOneScale (1.0 / [UIScreen mainScreen].scale)

#define kRGBA(r,g,b,a)           \
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kIs_Inch3_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIs_Inch4_0 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIs_Inch4_7 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIs_Inch5_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


///** 1 判断是否为3.5inch      320*480  */
//#define ONESCREEN ([UIScreen mainScreen].bounds.size.height == 480) 
///**  *  2 判断是否为4inch        640*1136  */
//#define TWOSCREEN ([UIScreen mainScreen].bounds.size.height == 568)
///**  *  3 判断是否为4.7inch   375*667   750*1334  */
//#define THREESCREEN ([UIScreen mainScreen].bounds.size.height == 667) 
///**  *  4 判断是否为5.5inch   414*1104   1242*2208  */
//#define FOURSCREEN ([UIScreen mainScreen].bounds.size.height == 1104)

#endif /* TUUIMacro_h */
