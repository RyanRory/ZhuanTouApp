//
//  ProductBuyConfirmViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/16.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetTradePswdViewController.h"
#import "SetpasswordViewController.h"
#import "TradePswdView.h"
#import "ForgottenViewController.h"

@interface ProductBuyConfirmViewController : UIViewController
{
    NSString *style;
    CGRect frame;
}

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *incomeRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *productTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amoutLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *realPayLabel;
@property (strong, nonatomic) IBOutlet UILabel *staIncome;
@property (strong, nonatomic) IBOutlet UILabel *youUsedLabel;
@property (strong, nonatomic) IBOutlet UILabel *voucher1Label;
@property (strong, nonatomic) IBOutlet UILabel *voucher1NumLabel;
@property (strong, nonatomic) IBOutlet UILabel *voucher2Label;
@property (strong, nonatomic) IBOutlet UILabel *voucher2NumLabel;
@property (strong, nonatomic) IBOutlet UIView *voucher1View;
@property (strong, nonatomic) IBOutlet UIView *voucher2View;

- (void)setStyle:(NSString*)str;

@property (strong, nonatomic) NSString *investAmount;
@property (strong, nonatomic) NSString *coupons;
@property (strong, nonatomic) NSString *vouchers;
@property (strong, nonatomic) NSString *idOrCode;
@property (strong, nonatomic) NSDictionary *productInfo;
@property (readwrite, nonatomic) id bonus;
@property (readwrite, nonatomic) id voucher1;
@property (readwrite, nonatomic) id voucher2;

@property (readwrite, nonatomic) BOOL isFromNewer;

@end
