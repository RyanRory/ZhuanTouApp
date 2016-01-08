//
//  SetpasswordViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/14.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliPayViews.h"
#import "KeychainData.h"
#import "RegisterSuccessViewController.h"
#import "LoginViewController.h"
#import "ZTTabBarViewController.h"

@interface SetpasswordViewController : UIViewController
{
    AliPayViews *alipay;
    NSString *oldPSW;
}
@property (strong, nonatomic) IBOutlet UIButton *forgottenButton;
@property (strong, nonatomic) IBOutlet UIButton *touchIdButton;
@property (strong, nonatomic) IBOutlet UIButton *forgottenButtonWithTouchId;

@property (readwrite, nonatomic) BOOL isFromNewer;

@property(nonatomic, copy)NSString *string;
@property(nonatomic, copy)NSString *style;

@end
