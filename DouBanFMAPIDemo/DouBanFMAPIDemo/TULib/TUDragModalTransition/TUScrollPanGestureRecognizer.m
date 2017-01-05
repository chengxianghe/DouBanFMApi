//
//  TUScrollPanGestureRecognizer.m
//  TestGestureTable
//
//  Created by chengxianghe on 16/5/31.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUScrollPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface TUScrollPanGestureRecognizer ()

@property (nonatomic, strong) NSNumber *isFail;

@end

@implementation TUScrollPanGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.isFail = nil;
    }
    return self;
}

- (void)reset {
    [super reset];
    self.isFail = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    if (self.scrollView == nil) {
        return;
    }
    
    if (self.state == UIGestureRecognizerStateFailed) {
        NSLog(@"touch Failed");
        
        return;
    }
    
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    
    if (self.isFail != nil) {
        if (self.isFail.boolValue) {
            self.state = UIGestureRecognizerStateFailed;
        }
        return;
    }
    
    CGFloat topVerticalOffset = -self.scrollView.contentInset.top;
    if (nowPoint.y > prevPoint.y && self.scrollView.contentOffset.y <= topVerticalOffset) {
        self.isFail = @(false);
    } else if (self.scrollView.contentOffset.y >= topVerticalOffset) {
        // In order to achieve some effects, may need to change here
        self.isFail = @(false);
    } else {
        self.isFail = @(false);
    }
}

@end