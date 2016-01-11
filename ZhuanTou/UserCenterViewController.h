//
//  UserCenterViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/24.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Background.h"
#import "PropertyTableViewCell.h"
#import "UserCenterTableViewCell.h"

#import "HuoqiViewController.h"
#import "DingqiViewController.h"
#import "ProfitViewController.h"
#import "DetailViewController.h"
#import "BonusViewController.h"
#import "BankCardViewController.h"
#import "ChargeViewController.h"
#import "DrawViewController.h"
#import "HelpMainViewController.h"
#import "RealNameViewController.h"
#import "SetTradePswdViewController.h"
#import "ResetTradePswdViewController.h"
#import "AllIncomeViewController.h"
#import "InvitationViewController.h"

#import "SetpasswordViewController.h"
#import "ZTTabBarViewController.h"

@interface UserCenterViewController : UIViewController<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary *data;
    CGRect frame;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UIButton *deSlideButton;
@property (strong, nonatomic) IBOutlet UIImageView *bigPortraitImageView;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *realNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *realNameButton;
@property (strong, nonatomic) IBOutlet UILabel *bankCardNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *bankCardButton;
@property (strong, nonatomic) IBOutlet UIButton *loginPswdButton;
@property (strong, nonatomic) IBOutlet UILabel *tradePswdLabel;
@property (strong, nonatomic) IBOutlet UIButton *tradePswdButton;
@property (strong, nonatomic) IBOutlet UIButton *gesturePswdButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIButton *signOutButton;

@end
