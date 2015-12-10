//
//  AutoViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/5.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleSwitch.h"
#import "SetpasswordViewController.h"

@interface AutoViewController : UIViewController
{
    BOOL flag;
}

@property (strong, nonatomic) IBOutlet SimpleSwitch *wenjianSwitch;
@property (strong, nonatomic) IBOutlet SimpleSwitch *wenjianAllSwitch;
@property (strong, nonatomic) IBOutlet UITextField *wenjianTextField;
@property (strong, nonatomic) IBOutlet UIView *wenjianAllView;
@property (strong, nonatomic) IBOutlet UIView *wenjianEditView;
@property (strong, nonatomic) IBOutlet SimpleSwitch *zongheSwitch;
@property (strong, nonatomic) IBOutlet SimpleSwitch *zongheAllSwitch;
@property (strong, nonatomic) IBOutlet UITextField *zongheTextField;
@property (strong, nonatomic) IBOutlet UIView *zongheAllView;
@property (strong, nonatomic) IBOutlet UIView *zongheEditView;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
