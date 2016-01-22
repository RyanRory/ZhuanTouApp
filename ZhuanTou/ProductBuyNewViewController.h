//
//  ProductBuyNewViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/20.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductBuyConfirmViewController.h"
#import "ChargeViewController.h"
#import "ProductBonusTableViewCell.h"
#import "WebDetailViewController.h"
#import "SetTradePswdViewController.h"
#import "ChooseBonusViewController.h"

@interface ProductBuyNewViewController : UIViewController
{
    NSMutableArray *bonus, *coupons, *standingCoupons;
    int bonusNum;
    double balance;
}

@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *chargeButton;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UILabel *restLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkboxButton;
@property (strong, nonatomic) IBOutlet UIButton *agreementButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) NSString *style;
@property (strong, nonatomic) NSString *coupon;
@property (strong, nonatomic) NSString *vouchers;
@property (readwrite ,nonatomic) id biggestBonus;
@property (readwrite ,nonatomic) id biggestCoupons;
@property (readwrite ,nonatomic) id biggestStandingCoupons;

@property (strong, nonatomic) NSString *idOrCode;
@property (strong, nonatomic) NSString *bidableAmount;
@property (strong, nonatomic) NSDictionary *productInfo;

@property (strong, nonatomic) IBOutlet UIView *bonusBgView;
@property (strong, nonatomic) IBOutlet UILabel *bonusNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusDDLLabel;
@property (strong, nonatomic) IBOutlet UIButton *bonusButton;
@property (strong, nonatomic) IBOutlet UIButton *bonusMoreButton;
@property (strong, nonatomic) IBOutlet UIView *bonusView;

@property (strong, nonatomic) IBOutlet UIView *couponsBgView;
@property (strong, nonatomic) IBOutlet UILabel *couponsNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponsLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponsDDLLabel;
@property (strong, nonatomic) IBOutlet UIButton *couponsButton;
@property (strong, nonatomic) IBOutlet UIButton *couponsMoreButton;
@property (strong, nonatomic) IBOutlet UIView *couponsView;

@property (strong, nonatomic) IBOutlet UIView *standingCouponsBgView;
@property (strong, nonatomic) IBOutlet UILabel *standingCouponsNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *standingCouponsLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *standingCouponsDDLLabel;
@property (strong, nonatomic) IBOutlet UIButton *standingCouponsButton;
@property (strong, nonatomic) IBOutlet UIButton *standingCouponsMoreButton;
@property (strong, nonatomic) IBOutlet UIView *standingCouponsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomLayOut;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (readwrite, nonatomic) BOOL isFromNewer;

- (void)setStyle:(NSString*)str;

- (IBAction)textFieldBeginEditing:(id)sender;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
