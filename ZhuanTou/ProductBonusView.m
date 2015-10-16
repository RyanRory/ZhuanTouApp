//
//  ProductBonusView.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/16.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductBonusView.h"

@implementation ProductBonusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        checkboxButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [checkboxButton setImage:[UIImage imageNamed:@"checkIcon.png"] forState:UIControlStateNormal];
        checkboxButton.selected = NO;
        [checkboxButton addTarget:self action:@selector(checkboxEnsure:) forControlEvents:UIControlEventTouchUpInside];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, frame.size.width-20, frame.size.height)];
        contentLabel.textColor = [UIColor lightGrayColor];
        [contentLabel setFont:[UIFont systemFontOfSize:11]];
        
        [self addSubview:checkboxButton];
        [self addSubview:contentLabel];
    }
    return self;
}

- (void)checkboxEnsure:(UIButton*)btn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [NSString stringWithString:[userDefaults objectForKey:ONLYONEBONUS]].boolValue;
    if (flag && (!btn.selected))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"只能选择一个红包" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        btn.selected = !btn.selected;
        if (btn.selected)
        {
            [btn setImage:[UIImage imageNamed:@"checkIconActive.png"] forState:UIControlStateNormal];
            [userDefaults setObject:@"1" forKey:ONLYONEBONUS];
            [userDefaults synchronize];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"checkIcon.png"] forState:UIControlStateNormal];
            [userDefaults setObject:@"0" forKey:ONLYONEBONUS];
            [userDefaults synchronize];
        }
    }
}

- (void)setContentLabelText:(NSString *)str
{
    contentLabel.text = str;
}

- (NSString*)getBonusID
{
    return bonusID;
}

- (void)setBonusID:(NSString*)str
{
    bonusID = str;
}

@end
