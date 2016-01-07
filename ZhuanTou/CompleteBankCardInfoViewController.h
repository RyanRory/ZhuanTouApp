//
//  CompleteBankCardInfoViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/7.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteBankCardInfoViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    MBProgressHUD *hud;
    NSArray *provinceArray, *cityArray;
    UIPickerView *picker;
    UIView *view, *bgView;
    UIToolbar *toolBar;
    int buttonTag;
    int provinceTemp, cityTemp;
}

@property (strong, nonatomic) IBOutlet UILabel *bankCardNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *chooseProvinceButton;
@property (strong, nonatomic) IBOutlet UILabel *provinceLabel;
@property (strong, nonatomic) IBOutlet UIButton *chooseCityButton;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UITextField *branchTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *bankName;
@property (strong, nonatomic) NSString *bankCardNum;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
