//
//  ForgottonResetViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/29.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgottonResetViewController : UIViewController
{
    NSString *style;
}

@property (strong, nonatomic) IBOutlet UIImageView *icon1;
@property (strong, nonatomic) IBOutlet UIImageView *icon2;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *pswdAgainTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

- (void)setStyle:(NSString*)str;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
