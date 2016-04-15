//
//  ResetTradePswdViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgottenViewController.h"

@interface ResetTradePswdViewController : ZTBaseViewController
{
    NSString *style;
}
@property (strong, nonatomic) IBOutlet UITextField *oldPswdTextField;
@property (strong, nonatomic) IBOutlet UITextField *nPswdTextTextField;
@property (strong, nonatomic) IBOutlet UITextField *nPswdAgainTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *forgetButton;
@property (strong, nonatomic) IBOutlet UIImageView *icon1;
@property (strong, nonatomic) IBOutlet UIImageView *icon2;
@property (strong, nonatomic) IBOutlet UIImageView *icon3;

@property (readwrite, nonatomic) BOOL isFromUserCenter;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

- (void)setStyle:(NSString *)str;
@end
