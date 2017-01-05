//
//  TUDragModalTransition.h
//  TestGestureTable
//
//  Created by chengxianghe on 16/5/31.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TUDragModalTransition : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSTimeInterval duration; // default 0.3
@property (nonatomic, assign) CGFloat behindViewAlpha; // default 0.5
@property (nonatomic, assign, readonly) BOOL presenting; // default true
@property (nonatomic, assign, readonly) BOOL isInteractive; // default false
@property (nonatomic,   weak, readonly) UIViewController *modalViewController;
@property (nonatomic,   weak, readonly) UIScrollView *scrollView;

- (instancetype)initWithViewController:(UIViewController *)viewController scrollView:(UIScrollView *)scrollView;

@end
