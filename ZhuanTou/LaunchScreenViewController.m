//
//  LaunchScreenViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/19.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "LaunchScreenViewController.h"

@interface LaunchScreenViewController ()

@end

@implementation LaunchScreenViewController

@synthesize centerImageView, bgView, titleLabel, discriptionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    bgView.layer.cornerRadius = 20;
    
    [centerImageView setAlpha:0.0f];
    [titleLabel setAlpha:0.0f];
    [discriptionLabel setAlpha:0.0f];

}

- (void)viewDidAppear:(BOOL)animated
{
    [bgView startAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:1.2f];
        [centerImageView setAlpha:1.0f];
        [UIView commitAnimations];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:1.5f];
        [titleLabel setAlpha:1.0f];
        [discriptionLabel setAlpha:1.0f];
        [UIView commitAnimations];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *password = [userDefault objectForKey:PASSWORD];
        if (password.length > 0)
        {
            SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
            setpass.string = @"验证密码";
            [[self navigationController]pushViewController:setpass animated:NO];
        }
        else
        {
            ZTTabBarViewController *tabvc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
            PPRevealSideViewController *revealSideViewController = [[PPRevealSideViewController alloc]initWithRootViewController:tabvc];
            [revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
            revealSideViewController.fakeiOS7StatusBarColor = [UIColor clearColor];
            [revealSideViewController setOption:PPRevealSideOptionsiOS7StatusBarMoving];
            LeftViewController *leftVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"LeftViewController"];
            [revealSideViewController preloadViewController:leftVC forSide:PPRevealSideDirectionLeft];
            [self presentViewController:revealSideViewController animated:NO completion:nil];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
