//
//  UserCenterMainViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/18.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleSwitch.h"
#import "HuoqiViewController.h"
#import "DingqiViewController.h"
#import "ProfitViewController.h"
#import "AutoViewController.h"
#import "SecurityViewController.h"
#import "DetailViewController.h"
#import "BonusViewController.h"
#import "BankCardViewController.h"

#import "SetpasswordViewController.h"
#import "ZTTabBarViewController.h"

@interface UserCenterMainViewController : UIViewController<UIGestureRecognizerDelegate>
{
    int t;
}

@property (strong, nonatomic) IBOutlet UILabel *propertyLabel;
@property (strong, nonatomic) IBOutlet UIButton *chargeButton;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *drawButton;
@property (strong, nonatomic) IBOutlet UILabel *dingqiNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *dingqiButton;
@property (strong, nonatomic) IBOutlet UILabel *huoqiNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *huoqiButton;
@property (strong, nonatomic) IBOutlet SimpleSwitch *autoSwitch;
@property (strong, nonatomic) IBOutlet UIButton *autoButton;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic) IBOutlet UIButton *profitButton;
@property (strong, nonatomic) IBOutlet UILabel *bankCardNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *bankCardButton;
@property (strong, nonatomic) IBOutlet UILabel *bonusNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *bonusButton;
@property (strong, nonatomic) IBOutlet UILabel *securityLabel;
@property (strong, nonatomic) IBOutlet UIButton *securityButton;
@property (strong, nonatomic) IBOutlet UIButton *gestureButton;

@end
