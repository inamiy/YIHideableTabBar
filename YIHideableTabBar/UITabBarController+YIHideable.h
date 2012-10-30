//
//  UITabBarController+Hideable.h
//  YIHideableTabBar
//
//  Created by Yasuhiro Inami on 12/10/30.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (YIHideable)

@property(nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;
@property(nonatomic, readonly, getter=isTabBarAnimating) BOOL tabBarAnimating;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

//
// NOTE:
// For above methods, default delaysContentResizing = NO.
// Set delaysContentResizing=YES when stretching UITableView, which often clips bottom content on bounds-change.
//
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated delaysContentResizing:(BOOL)delaysContentResizing completion:(void (^)(void))completion;

@end
