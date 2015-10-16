//
//  ProductBuyViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/16.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductBonusView.h"
#import "ProductBuyConfirmViewController.h"

@interface ProductBuyViewController : UIViewController
{
    NSString *style;
}
@property (strong, nonatomic) IBOutlet UIView *headBgView;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *chargeButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *tradePswdTextField;
@property (strong, nonatomic) IBOutlet UILabel *restLabel;
@property (strong, nonatomic) IBOutlet UILabel *noBonusLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkboxButton;
@property (strong, nonatomic) IBOutlet UIButton *agreementButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (void)setStyle:(NSString*)str;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
