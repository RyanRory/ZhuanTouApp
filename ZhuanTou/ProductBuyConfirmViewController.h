//
//  ProductBuyConfirmViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/16.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductBuyConfirmViewController : UIViewController
{
    NSString *style;
    CGRect frame;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet HeadView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *preIncomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *productTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowestIncomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amoutLabel;
@property (strong, nonatomic) IBOutlet UILabel *preIncomeNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *productTimeNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowestIncomeNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountNumLabel;
@property (strong, nonatomic) IBOutlet UIView *wenjianView;

@property (strong, nonatomic) IBOutlet HeadView *wenjianBgView;
- (void)setStyle:(NSString*)str;
@property (strong, nonatomic) IBOutlet UILabel *wenjianPILabel;
@property (strong, nonatomic) IBOutlet UILabel *wenjianPTLabel;
@property (strong, nonatomic) IBOutlet UILabel *wenjianAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *wenjianPINumLabel;
@property (strong, nonatomic) IBOutlet UILabel *wenjianPTNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *wenjianAmountNumLabel;

@end
