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
#import "AutoViewController.h"
#import "SecurityViewController.h"
#import "DetailViewController.h"
#import "BonusViewController.h"
#import "BankCardViewController.h"
#import "ChargeViewController.h"
#import "DrawViewController.h"

#import "SetpasswordViewController.h"
#import "ZTTabBarViewController.h"

@interface UserCenterViewController : UIViewController<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *data;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;

@end
