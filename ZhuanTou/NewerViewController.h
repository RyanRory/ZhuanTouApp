//
//  NewerViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/8.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "WebDetailViewController.h"
#import "ChargeViewController.h"
#import "ProductBuyNewViewController.h"

@interface NewerViewController : ZTBaseViewController
{
    int status, isHttpFinished;
    BOOL bonus1, bonus2;
    CGRect secureViewFrame, chargeViewFrame, investViewFrame, blueHandFrame;
    NSTimer *blueHandTimer, *shakeTimer, *shakeTimer1;
}

@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UIImageView *registerImage;
@property (strong, nonatomic) IBOutlet UILabel *registerLabel;
@property (strong, nonatomic) IBOutlet UILabel *registerDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIImageView *registerHand;
@property (strong, nonatomic) IBOutlet UIView *registerContentView;
@property (strong, nonatomic) IBOutlet UIButton *toRegisterButton;
@property (strong, nonatomic) IBOutlet UIImageView *registerLight;
@property (strong, nonatomic) IBOutlet UIImageView *registerBlueHand;
@property (strong, nonatomic) IBOutlet UIView *registerBonus;
@property (strong, nonatomic) IBOutlet UIImageView *registerBounsImageView;
@property (strong, nonatomic) IBOutlet UIImageView *registerBonusOpenedImageView;
@property (strong, nonatomic) IBOutlet UIButton *registerBonusButton;

@property (strong, nonatomic) IBOutlet UIView *secureView;
@property (strong, nonatomic) IBOutlet UIView *secureLine;
@property (strong, nonatomic) IBOutlet UIImageView *secureImage;
@property (strong, nonatomic) IBOutlet UILabel *secureLabel;
@property (strong, nonatomic) IBOutlet UILabel *secureDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *secureButton;
@property (strong, nonatomic) IBOutlet UIImageView *secureHand;
@property (strong, nonatomic) IBOutlet UIImageView *secureLight;
@property (strong, nonatomic) IBOutlet UIImageView *secureBlueHand;
@property (strong, nonatomic) IBOutlet UIView *secureContentView;
@property (strong, nonatomic) IBOutlet UITextField *realNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *idCardNoTextField;
@property (strong, nonatomic) IBOutlet UITextField *tradePswdTextField;
@property (strong, nonatomic) IBOutlet UITextField *tradePswdAgainTextField;
@property (strong, nonatomic) IBOutlet UIButton *secureConfirmButton;

@property (strong, nonatomic) IBOutlet UIView *chargeView;
@property (strong, nonatomic) IBOutlet UIView *chargeLine;
@property (strong, nonatomic) IBOutlet UIImageView *chargeImage;
@property (strong, nonatomic) IBOutlet UILabel *chargeLabel;
@property (strong, nonatomic) IBOutlet UILabel *chargeDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *chargeButton;
@property (strong, nonatomic) IBOutlet UIImageView *chargeHand;
@property (strong, nonatomic) IBOutlet UIImageView *chargeLight;
@property (strong, nonatomic) IBOutlet UIImageView *chargeBlueHand;
@property (strong, nonatomic) IBOutlet UIView *chargeContentView;
@property (strong, nonatomic) IBOutlet UIButton *toChargeButton;
@property (strong, nonatomic) IBOutlet UIButton *zongheDetailButton;
@property (strong, nonatomic) IBOutlet UIButton *wenjianDetailButton;
@property (strong, nonatomic) IBOutlet UIView *chargeZongheView;
@property (strong, nonatomic) IBOutlet UIView *chargeWenjianView;

@property (strong, nonatomic) IBOutlet UIView *investView;
@property (strong, nonatomic) IBOutlet UIView *investLine;
@property (strong, nonatomic) IBOutlet UIImageView *investImage;
@property (strong, nonatomic) IBOutlet UILabel *investLabel;
@property (strong, nonatomic) IBOutlet UILabel *investDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *investButton;
@property (strong, nonatomic) IBOutlet UIImageView *investHand;
@property (strong, nonatomic) IBOutlet UIImageView *investLight;
@property (strong, nonatomic) IBOutlet UIImageView *investBlueHand;
@property (strong, nonatomic) IBOutlet UIView *investContentView;
@property (strong, nonatomic) IBOutlet UIView *backLine;
@property (strong, nonatomic) IBOutlet UIButton *toBuyZonghe;
@property (strong, nonatomic) IBOutlet UIButton *toBuyWenjian;
@property (strong, nonatomic) IBOutlet UIView *investZongheView;
@property (strong, nonatomic) IBOutlet UIView *investWenjianView;
@property (strong, nonatomic) IBOutlet UIView *investBonus;
@property (strong, nonatomic) IBOutlet UIImageView *investBonusOpenedImageView;
@property (strong, nonatomic) IBOutlet UIImageView *investBonusImageView;
@property (strong, nonatomic) IBOutlet UIButton *investBonusButton;

- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)buttonEnableListener:(id)sender;

@end
