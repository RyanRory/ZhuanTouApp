//
//  ZTTabBarViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/15.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ZTTabBarViewController.h"

@interface ZTTabBarViewController ()

@end

@implementation ZTTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *items = self.tabBar.items;
    UITabBarItem *homeItem = items[0];
    homeItem.image = [[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem.selectedImage = [[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTLIGHTGRAY,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];//正常
    [homeItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTBLUE,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];//被选中
    
    UITabBarItem *productItem = items[1];
    productItem.image = [[UIImage imageNamed:@"productActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    productItem.selectedImage = [[UIImage imageNamed:@"productActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [productItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTLIGHTGRAY,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];//正常
    [productItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTBLUE,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];//被选中
    
    UITabBarItem *accountItem = items[2];
    accountItem.image = [[UIImage imageNamed:@"account.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    accountItem.selectedImage = [[UIImage imageNamed:@"account.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [accountItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTLIGHTGRAY,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];//正常
    [accountItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTBLUE,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];//被选中
    
    UITabBarItem *helpItem = items[3];
    helpItem.image = [[UIImage imageNamed:@"help.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    helpItem.selectedImage = [[UIImage imageNamed:@"help.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [helpItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTLIGHTGRAY,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];//正常
    [helpItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTBLUE,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];//被选中

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
