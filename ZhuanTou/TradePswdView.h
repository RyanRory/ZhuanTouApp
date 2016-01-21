//
//  TradePswdView.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/20.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PasswordBlock) (NSString *pswString);

@interface TradePswdView : UIView

@property(strong, nonatomic) UIView *centerView;
@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UITextField *hiddenTextField;
@property(strong, nonatomic) UITextField *textField1;
@property(strong, nonatomic) UITextField *textField2;
@property(strong, nonatomic) UITextField *textField3;
@property(strong, nonatomic) UITextField *textField4;
@property(strong, nonatomic) UITextField *textField5;
@property(strong, nonatomic) UITextField *textField6;
@property(strong, nonatomic) UIButton *cancelButton;
@property(strong, nonatomic) UIView *lineView;

@property(nonatomic , strong)PasswordBlock block;

- (void)showView;

@end
