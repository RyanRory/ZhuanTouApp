//
//  AddBankCardViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/30.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBankCardViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    MBProgressHUD *hud;
    NSArray *bankArray, *provinceArray, *cityArray;
    UIPickerView *picker;
    UIView *view;
    UIToolbar *toolBar;
    int buttonTag;
    int bankTemp, provinceTemp, cityTemp;
    NSString *fullName;
}

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *accountNumTextField;
@property (strong, nonatomic) IBOutlet UITextField *bankTextField;
@property (strong, nonatomic) IBOutlet UILabel *bankLabel;
@property (strong, nonatomic) IBOutlet UILabel *provinceLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UIButton *bankButton;
@property (strong, nonatomic) IBOutlet UIButton *provinceButton;
@property (strong, nonatomic) IBOutlet UIButton *cityButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumTextField;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

- (void)setFullName:(NSString*)str;

@end
