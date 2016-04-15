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

@synthesize lastSelectedIndex, isRegister;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    NSArray *items = self.tabBar.items;
    UITabBarItem *homeItem = items[0];
    homeItem.image = [[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem.selectedImage = [[UIImage imageNamed:@"homeActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTLIGHTGRAY,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];//正常
    [homeItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTBLUE,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];//被选中
    
    UITabBarItem *productItem = items[1];
    productItem.image = [[UIImage imageNamed:@"product.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    productItem.selectedImage = [[UIImage imageNamed:@"productActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [productItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTLIGHTGRAY,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];//正常
    [productItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTBLUE,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];//被选中
    
    UITabBarItem *accountItem = items[2];
    accountItem.title = @"我的账户";
    accountItem.image = [[UIImage imageNamed:@"account.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    accountItem.selectedImage = [[UIImage imageNamed:@"accountActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [accountItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTLIGHTGRAY,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];//正常
    [accountItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTBLUE,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];//被选中
    
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.userInfo.count > 0)
    {
        NSString *afterOpen = [app.userInfo objectForKey:@"after_open"];
        if ([afterOpen isEqualToString:@"go_activity"])
        {
            NSString *activity = [app.userInfo objectForKey:@"activity"];
            if ([activity isEqualToString:@"endedDq"])
            {
                [self setSelectedIndex:2];
            }
            else
            {
                [self setSelectedIndex:1];
            }
        }
    }
    
    isRegister = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    //判断是否相等,不同才设置
    if (self.selectedIndex != selectedIndex) {
        //设置最近一次
        lastSelectedIndex = self.selectedIndex;
    }
    [super setSelectedIndex:selectedIndex];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex != self.selectedIndex) {
        //设置最近一次变更
        lastSelectedIndex = self.selectedIndex;
    }
}


@end
