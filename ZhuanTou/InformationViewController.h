//
//  InformationViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/14.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliPayViews.h"
#import "KeychainData.h"
#import "ZTBaseViewController.h"

#import "SetpasswordViewController.h"

@interface InformationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *textView;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *pswdAgainTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UITextField *recommendTextField;

@property (readwrite, nonatomic) BOOL isFromNewer;
@property (readwrite, nonatomic) NSString *smsCode;
@property (readwrite, nonatomic) NSString *phoneNum;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
