//
//  SecurityViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealNameViewController.h"
#import "SetTradePswdViewController.h"
#import "ResetTradePswdViewController.h"

@interface SecurityViewController : UIViewController
{
    int i;
}
@property (strong, nonatomic) IBOutlet UIImageView *pointerImageView;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UILabel *realNameStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *tradePswdStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *realNameButton;
@property (strong, nonatomic) IBOutlet UIButton *tradePswdButton;
@property (strong, nonatomic) IBOutlet UIButton *loginPswdButton;

- (void)setLevel:(int)temp;

@end
