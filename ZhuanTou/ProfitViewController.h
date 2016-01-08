//
//  ProfitViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/20.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>
#import "ZhuanTou-Bridging-Header.h"
#import "SetpasswordViewController.h"
#import "ChargeViewController.h"
#import "DrawViewController.h"

@interface ProfitViewController : UIViewController<ChartViewDelegate>
{
    double dingqi, huoqi, balance, frozen, total;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *dingqiPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *huoqiPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *balancePercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *dingqiNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *huoqiNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceNumLabel;
@property (strong, nonatomic) IBOutlet PieChartView *pieChartView;
@property (strong, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *frozenPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *frozenNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *chargeButton;
@property (strong, nonatomic) IBOutlet UIButton *drawButton;

@end
