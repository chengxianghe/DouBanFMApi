//
//  TUDragModalTransition.m
//  TestGestureTable
//
//  Created by chengxianghe on 16/5/31.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUDragModalTransition.h"
#import "TUScrollPanGestureRecognizer.h"

@interface TUDragModalTransition ()

@property (nonatomic, strong) TUScrollPanGestureRecognizer *panGesture;
@property (nonatomic, assign) BOOL presenting; // default true
@property (nonatomic, assign) BOOL isInteractive; // default false
@property (nonatomic,   weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) CGFloat panLocationStart;

@end

@implementation TUDragModalTransition

- (instancetype)initWithViewController:(UIViewController *)viewController scrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        _modalViewController = viewController;
        _scrollView = scrollView;
        self.presenting = true;
        self.isInteractive = false;
        self.duration = 0.3;
        self.behindViewAlpha = 0.5;
        self.panGesture = [[TUScrollPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.panGesture.delegate = self;
        self.panGesture.scrollView = scrollView;
        [self.modalViewController.view addGestureRecognizer:self.panGesture];
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    // Position the presented view off the top of the container view
    fromControllerView.frame = [transitionContext finalFrameForViewController:fromController];
    
    if (self.presenting) {
        fromControllerView.center = CGPointMake(fromControllerView.center.x, containerView.bounds.size.height);
    }
    
    [containerView addSubview:fromControllerView];
    
    // Animate the presented view to it's final position
    [UIView animateWithDuration:self.duration animations:^{
        if (self.presenting) {
            fromControllerView.center = CGPointMake(fromControllerView.center.x, fromControllerView.center.y - containerView.bounds.size.height);
        } else {
            fromControllerView.center = CGPointMake(fromControllerView.center.x, fromControllerView.center.y + containerView.bounds.size.height);
        }
    } completion:^(BOOL completed){
        [transitionContext completeTransition:completed];
    }];
}

// return how many seconds the transiton animation will take
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)handlePan:(TUScrollPanGestureRecognizer *)recognizer {
    // Location reference
    CGPoint location = [recognizer locationInView:self.modalViewController.view.window];
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(recognizer.view.transform));
    
    // Velocity reference
    CGPoint velocity = [recognizer velocityInView:self.modalViewController.view.window];
    velocity = CGPointApplyAffineTransform(velocity, CGAffineTransformInvert(recognizer.view.transform));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        self.isInteractive = true;
        self.panLocationStart = location.y + self.panGesture.scrollView.contentOffset.y + 64;
        [self.modalViewController dismissViewControllerAnimated:true completion:nil];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat animationRatio = (location.y - self.panLocationStart) / (CGRectGetHeight(self.modalViewController.view.bounds));
//        print(location.y);
        
        [self updateInteractiveTransition:animationRatio];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGFloat velocityForSelectedDirection = velocity.y;
        if (velocityForSelectedDirection > 200 && self.panGesture.scrollView.contentOffset.y <= 0) {
            [self finishInteractiveTransition];
        } else {
            [self cancelInteractiveTransition];
        }
        
        self.isInteractive = false;
    }
}

// MARK: UIViewControllerInteractiveTransitioning protocol methods

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [toViewController beginAppearanceTransition:!self.presenting animated:true];
    toViewController.view.alpha = self.behindViewAlpha;
    [[transitionContext containerView] bringSubviewToFront:fromViewController.view];
    
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toViewController.view.alpha = self.behindViewAlpha + ((1 - self.behindViewAlpha) * percentComplete);
    
    CGRect updateRect = CGRectMake(0,
                                   (CGRectGetHeight(fromViewController.view.bounds) * percentComplete),
                                   CGRectGetWidth(fromViewController.view.frame),
                                   CGRectGetHeight(fromViewController.view.frame));
    
    if (isnan(updateRect.origin.y) || isinf(updateRect.origin.y)) {
        updateRect.origin.y = 0;
    }
    
    CGPoint transformedPoint = CGPointApplyAffineTransform(updateRect.origin, fromViewController.view.transform);
    updateRect = CGRectMake(transformedPoint.x, transformedPoint.y, updateRect.size.width, updateRect.size.height);
    
    if (updateRect.origin.y < 0)  {
        updateRect.origin.y = 0;
    }
    
    fromViewController.view.frame = updateRect;
}

- (void)finishInteractiveTransition {
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endRect = CGRectMake(0,
                                     CGRectGetHeight(fromViewController.view.bounds),
                                     CGRectGetWidth(fromViewController.view.frame),
                                     CGRectGetHeight(fromViewController.view.frame));
    
    CGPoint transformedPoint = CGPointApplyAffineTransform(endRect.origin, fromViewController.view.transform);
    endRect = CGRectMake(transformedPoint.x, transformedPoint.y, endRect.size.width, endRect.size.height);
    
    [UIView animateWithDuration:self.duration animations:^{
        toViewController.view.alpha = 1.0;
        fromViewController.view.frame = endRect;
    } completion:^(BOOL finished) {
        [toViewController endAppearanceTransition];
        [transitionContext completeTransition:true];
    }];
}

- (void)cancelInteractiveTransition {
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [toViewController beginAppearanceTransition:false animated:true];
    
    [UIView animateWithDuration:self.duration animations:^{
        toViewController.view.alpha = self.behindViewAlpha;
        fromViewController.view.frame = CGRectMake(0,0,
                                                   CGRectGetWidth(fromViewController.view.frame),
                                                   CGRectGetHeight(fromViewController.view.frame));
    } completion:^(BOOL finished) {
        [toViewController endAppearanceTransition];
        [transitionContext completeTransition:false];
    }];
}

// MARK: UIViewControllerTransitioningDelegate protocol methods

// return the animataor when presenting a viewcontroller
// remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presenting = true;
    return self;
}


// return the animator used when dismissing from a viewcontroller
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presenting = false;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    // Return nil if we are not interactive
    if (self.isInteractive) {
        self.presenting = false;
        return self;
    }
    
    return nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

@end