//
//  QuitAlertView.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/22.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Block)(id object);

@interface QuitAlertView : UIView

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UIButton *confirmButton;
@property(strong, nonatomic) UIButton *cancelButton;
@property(strong, nonatomic) UIView *lineView1;
@property(strong, nonatomic) UIView *lineView2;

@property(nonatomic , strong)Block block;

- (void)showView;

@end
