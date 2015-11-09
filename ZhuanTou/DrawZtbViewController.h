//
//  DrawZtbViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/9.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawZtbViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UITextField *drawNumTextField;
@property (strong, nonatomic) IBOutlet UITextField *tradePswdTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
