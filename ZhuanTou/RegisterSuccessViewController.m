//
//  RegisterSuccessViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/15.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "RegisterSuccessViewController.h"

@interface RegisterSuccessViewController ()

@end

@implementation RegisterSuccessViewController

@synthesize newerButton, gotoHomePageButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    [newerButton addTarget:self action:@selector(toNewerReward:) forControlEvents:UIControlEventTouchUpInside];
    newerButton.layer.cornerRadius = 3;
    
    gotoHomePageButton.layer.cornerRadius = 3;
    gotoHomePageButton.layer.borderWidth = 1;
    gotoHomePageButton.layer.borderColor = ZTBLUE.CGColor;
    [gotoHomePageButton addTarget:self action:@selector(gotoHomePage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)toNewerReward:(id)sender
{
    ZTTabBarViewController *tabVC = (ZTTabBarViewController*)[self.navigationController presentingViewController];
    tabVC.isRegister = 1;
    [tabVC setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoHomePage:(id)sender
{
    ZTTabBarViewController *tabVC = (ZTTabBarViewController*)[self.navigationController presentingViewController];
    tabVC.isRegister = 0;
    [tabVC setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
