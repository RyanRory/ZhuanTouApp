//
//  AppDelegate.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/9/28.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sys/sysctl.h"
#import "LaunchScreenViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,QQApiInterfaceDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readwrite, nonatomic) NSString *realNameString;
@property (readwrite, nonatomic) NSString *phonenumString;
@property (readwrite, nonatomic) NSDictionary *userInfo;

@end

