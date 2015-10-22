//
//  SetTradePswdViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTradePswdViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *tradePswdTextField;
@property (strong, nonatomic) IBOutlet UITextField *tradePswdAgainTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;


@end
