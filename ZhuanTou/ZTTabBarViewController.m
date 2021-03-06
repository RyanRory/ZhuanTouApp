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
    accountItem.image = [[UIImage imageNamed:@"account.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    accountItem.selectedImage = [[UIImage imageNamed:@"accountActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [accountItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTLIGHTGRAY,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];//正常
    [accountItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTBLUE,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];//被选中
    
    UITabBarItem *helpItem = items[3];
    helpItem.image = [[UIImage imageNamed:@"help.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    helpItem.selectedImage = [[UIImage imageNamed:@"helpActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [helpItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTLIGHTGRAY,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];//正常
    [helpItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZTBLUE,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];//被选中

//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *password = [userDefault objectForKey:PASSWORD];
//    if ((password.length > 0) && (![userDefault boolForKey:ISLOGIN]))
//    {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSDictionary *parameters = @{@"login":[userDefault objectForKey:USERNAME],
//                                     @"password":[userDefault objectForKey:PASSWORD]};
//        NSString *URL = [BASEURL stringByAppendingString:@"api/auth/signIn"];
//        [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//            NSLog(@"%@", responseObject);
//            NSString *str = [responseObject objectForKey:@"isAuthenticated"];
//            int f1 = str.intValue;
//            if (f1 == 0)
//            {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeCustomView;
//                NSRange range = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorMessage"]] rangeOfString:@"密码错误"];
//                if (range.length > 0)
//                {
//                    hud.labelText = @"您的登录密码已修改，请重新登录";
//                    [userDefault removeObjectForKey:PASSWORD];
//                    [userDefault synchronize];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
//                        [self presentViewController:nav animated:YES completion:nil];
//                    });
//                }
//                else
//                {
//                    hud.labelText = [responseObject objectForKey:@"errorMessage"];
//                }
//                [hud hide:YES afterDelay:1.5f];
//            }
//            else
//            {
//                [userDefault setBool:YES forKey:ISLOGIN];
//                [userDefault setBool:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isTradepasswordset"]].boolValue forKey:ISTRADEPSWDSET];
//                [userDefault synchronize];
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"登录失败";
//            [hud hide:YES afterDelay:1.5f];
//            
//        }];
//    }
    
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
