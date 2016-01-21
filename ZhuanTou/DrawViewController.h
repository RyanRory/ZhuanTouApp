//
//  DrawViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/1.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddBankCardViewController.h"
#import "RealNameViewController.h"
#import "CompleteBankCardInfoViewController.h"

@interface DrawViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    MBProgressHUD *hud;
    NSArray *bankArray, *provinceArray, *cityArray;
    UIPickerView *picker;
    UIView *view, *bgView;
    UIToolbar *toolBar;
    int buttonTag, secondsCountDown;
    int bankTemp, provinceTemp, cityTemp;
    NSTimer *countDownTimer;
}

@property (strong, nonatomic) IBOutlet UIView *bankCardView;
@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *branchLabel;
@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *drawNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UITextField *editTextField;
@property (strong, nonatomic) IBOutlet UILabel *drawCostLabel;
@property (strong, nonatomic) IBOutlet UILabel *noFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *drawPreTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *drawCostDescriptionLabel;


@property (strong, nonatomic) IBOutlet UIView *noBankCardView;
@property (strong, nonatomic) IBOutlet UITextField *bankcardNoTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *chooseBankButton;
@property (strong, nonatomic) IBOutlet UILabel *bankLabel;
@property (strong, nonatomic) IBOutlet UIButton *chooseProvinceButton;
@property (strong, nonatomic) IBOutlet UILabel *provinceLabel;
@property (strong, nonatomic) IBOutlet UIButton *chooseCityButton;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UITextField *branchTextField;
@property (strong, nonatomic) IBOutlet UIButton *NBCVconfirmButton;
@property (strong, nonatomic) IBOutlet UITextField *drawNumTextField;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *NBCVnoFeeNumLabel;
@property (strong, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property (strong, nonatomic) IBOutlet UILabel *preTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *getSmsCodeButton;

@property (readwrite, nonatomic) BOOL isFromUserCenter;


- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

- (IBAction)NBCVconfirmButtonEnableListener:(id)sender;

@end
