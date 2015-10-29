//
//  ForgottenViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/29.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneVcodeViewController.h"

@interface ForgottenViewController : UIViewController
{
    NSString *style;
    NSData *imageData;
}

@property (strong, nonatomic) IBOutlet UIView *phoneView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIView *vcodeView;
@property (strong, nonatomic) IBOutlet UITextField *vcodeTextField;
@property (strong, nonatomic) IBOutlet UIButton *vcodeImageView;
@property (strong, nonatomic) IBOutlet UIButton *changeButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (void)setStyle:(NSString*)str;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
