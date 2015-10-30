//
//  BankCardViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/30.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddBankCardViewController.h"

@interface BankCardViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *bankCardView;
@property (strong, nonatomic) IBOutlet UIImageView *bankImage;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *branchLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *noBankCardView;
@property (strong, nonatomic) IBOutlet UIButton *addBankCardButton;
@property (strong, nonatomic) IBOutlet UILabel *oneLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLimitLabel;

@end
