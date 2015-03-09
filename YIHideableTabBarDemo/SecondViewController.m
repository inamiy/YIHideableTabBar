//
//  SecondViewController.m
//  YIHideableTabBarDemo
//
//  Created by Yasuhiro Inami on 12/10/30.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "SecondViewController.h"

//
// NOTE:
// This flag doesn't change the behavior very much in this example (I don't know why...),
// but actually needed for my other project.
//
#define DELAYS_CONTENT_RESIZING     NO

@interface SecondViewController ()

@end

@implementation SecondViewController

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
        [self.tabBarController setTabBarHidden:NO animated:YES delaysContentResizing:DELAYS_CONTENT_RESIZING completion:NULL];
    }
    else {
        // hide tabBar
        [self.tabBarController setTabBarHidden:YES animated:YES delaysContentResizing:DELAYS_CONTENT_RESIZING completion:NULL];
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
            [self.tabBarController setTabBarHidden:NO animated:YES delaysContentResizing:DELAYS_CONTENT_RESIZING completion:NULL];
        });
    }
    else {
        // hide tabBar
        __weak SecondViewController *weakSelf = self;
        [self.tabBarController setTabBarHidden:YES animated:YES delaysContentResizing:DELAYS_CONTENT_RESIZING completion:^{
            // show toolbar
            [weakSelf.navigationController setToolbarHidden:NO animated:YES];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self handleTabBarButton:nil];
}

@end
