//
//  LeftViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/21.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    ZTTabBarViewController *tabVC = (ZTTabBarViewController*)self.revealSideViewController.rootViewController;
    [tabVC.selectedViewController.view setUserInteractionEnabled:YES];
    [tabVC.tabBar setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
