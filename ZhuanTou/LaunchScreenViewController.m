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

@synthesize bgImageView, centerImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bgImage = [UIImage imageNamed:@"launchBg.png"];
    bgImage = [bgImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    bgImageView.image = bgImage;
    bgImageView.tintColor = [UIColor whiteColor];
    
    UIImage *centerImage = [UIImage imageNamed:@"launchCenter.png"];
    centerImage = [centerImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    centerImageView.image = centerImage;
    centerImageView.tintColor = ZTBLUE;
}

- (void)viewDidAppear:(BOOL)animated
{
    centerImageView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:2.0f];
    [bgImageView setTintColor:ZTBLUE];
    [centerImageView setTintColor:[UIColor whiteColor]];
    centerImageView.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView commitAnimations];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZTTabBarViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
        [self presentViewController:vc animated:NO completion:nil];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
