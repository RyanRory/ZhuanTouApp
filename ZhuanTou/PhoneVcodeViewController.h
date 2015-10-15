//
//  PhoneVcodeViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/14.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationViewController.h"

@interface PhoneVcodeViewController : UIViewController
{
    int secondsCountDown;
    NSTimer *countDownTimer;
    NSString *phoneNum;
    NSString *vCode;
}
@property (strong, nonatomic) IBOutlet UIView *textView;
@property (strong, nonatomic) IBOutlet UITextField *phoneVcodeTextField;
@property (strong, nonatomic) IBOutlet UIButton *getVcodeButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
