//
//  AllIncomeViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/11.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>
#import "ZhuanTou-Bridging-Header.h"
#import "SetpasswordViewController.h"

@interface AllIncomeViewController : ZTBaseViewController<ChartViewDelegate>
{
    double fhb, wyb, ztb, other, total;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *fhbPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *wybPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *ztbPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *fhbNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *wybNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *ztbNumLabel;
@property (strong, nonatomic) IBOutlet PieChartView *pieChartView;
@property (strong, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *otherPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *otherNumLabel;

@end
