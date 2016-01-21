//
//  BonusViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/25.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonusTableViewCell.h"
#import "VoucherTableViewCell.h"
#import "ZTTabBarViewController.h"
#import "SetpasswordViewController.h"

@interface BonusViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    int bonusNum;
    NSMutableArray *datas, *bonusDatas, *interestRateDatas;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UIButton *bonusButton;
@property (strong, nonatomic) IBOutlet UIButton *interestRateButton;
@property (strong, nonatomic) IBOutlet UILabel *noBonusLabel;

@end
