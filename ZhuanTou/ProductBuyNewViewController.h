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
#import "ProductCouponsTableViewCell.h"
#import "ProductVoucherTableViewCell.h"
#import "ProductLabelTableViewCell.h"

@interface ProductBuyNewViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *bonus, *coupons, *standingCoupons;
    int bonusNum;
    double balance;
    BOOL couponsFlag, voucher1Flag, voucher2Flag;
    BOOL bonusLoadFinished, couponLoadFinished;
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

@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UIButton *allInButton;
@property (strong, nonatomic) IBOutlet UIButton *checkboxBigButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomLayOut;
@property (readwrite, nonatomic) BOOL isFromNewer;

@property (readwrite, nonatomic) BOOL couponsFlagChosen;
@property (readwrite, nonatomic) BOOL voucher1FlagChosen;
@property (readwrite, nonatomic) BOOL voucher2FlagChosen;


- (void)setStyle:(NSString*)str;

- (IBAction)textFieldBeginEditing:(id)sender;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
