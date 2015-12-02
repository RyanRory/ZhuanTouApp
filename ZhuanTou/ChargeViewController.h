//
//  ChargeViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/1.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaoFooPay/BaoFooPay.h>
#import "AddBankCardViewController.h"
#import "RealNameViewController.h"
#import "LLPaySdk.h"

@interface ChargeViewController : UIViewController<BaofooSdkDelegate, LLPaySdkDelegate>

@property (strong, nonatomic) IBOutlet UIView *bankCardView;
@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *branchLabel;
@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UILabel *oneLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLimitLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UITextField *editTextField;
@property (strong, nonatomic) IBOutlet UIView *noBankCardView;
@property (strong, nonatomic) IBOutlet UIButton *addBankCardButton;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
