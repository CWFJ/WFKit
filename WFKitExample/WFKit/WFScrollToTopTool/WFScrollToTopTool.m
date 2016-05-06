//
//  WFScrollToTopTool.m
//  WFKit
//
//  Created by Jason on 16/5/6.
//  Copyright © 2016年 Jason. All rights reserved.
//  若出现Status Bar不显示，请在info.plist中设置 UIViewControllerBasedStatusBarAppearance  为NO

#import "WFScrollToTopTool.h"
#import <UIKit/UIKit.h>

@implementation WFScrollToTopTool

static UIWindow *_window;

+ (void)tapHandle {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superview {

    [superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subview isKindOfClass:[UIScrollView class]] && [self isShowingOnKeyWindow:subview]) {
            CGPoint offset = ((UIScrollView *)subview).contentOffset;
            offset.y = - ((UIScrollView *)subview).contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        [self searchScrollViewInView:subview];
    }];
}

+ (BOOL)isShowingOnKeyWindow:(UIView *)view {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect newFrame = [keyWindow convertRect:view.frame fromView:view.superview];
    CGRect winBounds = keyWindow.bounds;
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    return !view.isHidden && view.alpha > 0.01 && view.window == keyWindow && intersects;
}

+ (void)initialize {
    _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    _window.windowLevel = UIWindowLevelAlert;
    _window.rootViewController = [[UIViewController alloc] init];
    _window.backgroundColor = [UIColor clearColor];
    [_window addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)]];
}

#pragma mark ------<启动服务>
/**
 *  启动服务
 */
+ (void)start {
    _window.hidden = NO;
}

#pragma mark ------<停止服务>
/**
 *  停止服务
 */
+ (void)stop {
    _window.hidden = YES;
}
@end
