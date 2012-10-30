//
//  FirstViewController.m
//  YIHideableTabBarDemo
//
//  Created by Yasuhiro Inami on 12/10/30.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)handleTabBarButton:(id)sender
{
    BOOL isTabBarHidden = [self.tabBarController isTabBarHidden];
    if (isTabBarHidden) {
        // show tabBar
        [self.tabBarController setTabBarHidden:NO animated:YES completion:NULL];
    }
    else {
        // hide tabBar
        [self.tabBarController setTabBarHidden:YES animated:YES completion:NULL];
    }
}

- (IBAction)handleToggleButton:(id)sender 
{
    // don't handle when quick-toggling tabBar/toolbar
    if (self.tabBarController.isTabBarAnimating) return;
    
    BOOL isTabBarHidden = [self.tabBarController isTabBarHidden];
    if (isTabBarHidden) {
        
        // hide toolbar
        [self.navigationController setToolbarHidden:YES animated:YES];
        
        // show tabBar
        double delayInSeconds = UINavigationControllerHideShowBarDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tabBarController setTabBarHidden:NO animated:YES completion:NULL];
        });
    }
    else {
        // hide tabBar
        [self.tabBarController setTabBarHidden:YES animated:YES completion:^{
            // show toolbar
            [self.navigationController setToolbarHidden:NO animated:YES];
        }];
    }
}

@end
