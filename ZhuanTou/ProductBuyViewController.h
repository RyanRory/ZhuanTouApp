//
//  ProductBuyViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/16.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductBuyConfirmViewController.h"
#import "ChargeViewController.h"
#import "ProductBonusTableViewCell.h"
#import "WebDetailViewController.h"
#import "SetTradePswdViewController.h"

@interface ProductBuyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSString *coupons;
    NSMutableArray *datas;
    int bonusNum;
    double balance;
}
@property (strong, nonatomic) IBOutlet UIView *headBgView;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *chargeButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UILabel *restLabel;
@property (strong, nonatomic) IBOutlet UILabel *noBonusLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkboxButton;
@property (strong, nonatomic) IBOutlet UIButton *agreementButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSString *style;
@property (strong, nonatomic) IBOutlet UITableView *tView;

@property (strong, nonatomic) NSString *idOrCode;
@property (strong, nonatomic) NSString *bidableAmount;
@property (strong, nonatomic) NSDictionary *productInfo;

@property (readwrite, nonatomic) BOOL isFromNewer;

- (void)setStyle:(NSString*)str;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
