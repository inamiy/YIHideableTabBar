//
//  UITabBarController+Hideable.m
//  YIHideableTabBar
//
//  Created by Yasuhiro Inami on 12/10/30.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "UITabBarController+YIHideable.h"
#import <objc/runtime.h>

const char __isTabBarAnimatingKey;


@implementation UITabBarController (YIHideable)

- (BOOL)isTabBarAnimating
{
    return [objc_getAssociatedObject(self, &__isTabBarAnimatingKey) boolValue];
}

- (void)_setTabBarAnimating:(BOOL)tabBarAnimating
{
    objc_setAssociatedObject(self, &__isTabBarAnimatingKey, [NSNumber numberWithBool:tabBarAnimating], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTabBarHidden
{
    return self.tabBar.hidden;
}

- (void)setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:NO completion:NULL];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    [self setTabBarHidden:hidden animated:animated delaysContentResizing:NO completion:NULL];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self setTabBarHidden:hidden animated:animated delaysContentResizing:NO completion:completion];
}

// modified
// http://www.iphonedevsdk.com/forum/iphone-sdk-development/4091-uitabbarcontroller-hidden-uitabbar.html
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated delaysContentResizing:(BOOL)delaysContentResizing completion:(void (^)(void))completion
{
    if ( [self.view.subviews count] < 2 ) return;
    
    UIView *transitionView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        transitionView = [self.view.subviews objectAtIndex:1]; // iOS4?
    }
    else {
        transitionView = [self.view.subviews objectAtIndex:0]; // UITransitionView in iOS5
    }
    
    if (!hidden) {
        self.tabBar.hidden = NO;
    }
    
    [self _setTabBarAnimating:YES];
    
    [UIView animateWithDuration:(animated ? UINavigationControllerHideShowBarDuration : 0)
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         CGFloat tabBarTop = 0;
                         
                         if (hidden) {
                             CGRect viewFrame = [self.view convertRect:self.view.bounds toView:self.tabBar.superview];
                             tabBarTop = viewFrame.origin.y+viewFrame.size.height;
                             
                             transitionView.frame = self.view.bounds;
                         }
                         else {
                             CGRect viewFrame = [self.view convertRect:self.view.bounds toView:self.tabBar.superview];
                             tabBarTop = viewFrame.origin.y+viewFrame.size.height-self.tabBar.frame.size.height;
                             
                             if (!delaysContentResizing) {
                                 transitionView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                   self.view.bounds.origin.y,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height-self.tabBar.frame.size.height);
                             }
                         }
                         
                         CGRect frame;
                         frame = self.tabBar.frame;
                         frame.origin.y = tabBarTop;
                         self.tabBar.frame = frame;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if (hidden) {
                             self.tabBar.hidden = YES;
                         }
                         else {
                             if (delaysContentResizing && finished) {
                                 transitionView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                   self.view.bounds.origin.y,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - self.tabBar.frame.size.height);
                             }
                         }
                         
                         [self _setTabBarAnimating:NO];
                         
                         if (completion) {
                             completion();
                         }
                         
                     }];
}

@end
