//
//  QuitAlertView.m
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/22.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "QuitAlertView.h"

@implementation QuitAlertView

@synthesize titleLabel, confirmButton, cancelButton, lineView1, lineView2;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.layer.cornerRadius = 20;
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"您确定行使首笔投资退出特权吗？";
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, frame.size.width, 1)];
        lineView1.backgroundColor = [UIColor whiteColor];
        lineView2 = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width-1)/2, 61, 1, 45)];
        lineView2.backgroundColor = [UIColor whiteColor];
        
        confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2, 61, frame.size.width/2, 40)];
        [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 61, frame.size.width/2, 40)];
        [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 61, frame.size.width/2, 30)];
        label1.textColor = [UIColor whiteColor];
        label1.text = @"否";
        label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        label1.textAlignment = NSTextAlignmentCenter;
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 91, frame.size.width/2, 10)];
        label2.textColor = [UIColor whiteColor];
        label2.text = @"持有到期拿返现";
        label2.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];
        label2.textAlignment = NSTextAlignmentCenter;
        
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2, 61, frame.size.width/2, 30)];
        label3.textColor = [UIColor whiteColor];
        label3.text = @"是";
        label3.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        label3.textAlignment = NSTextAlignmentCenter;
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2, 91, frame.size.width/2, 10)];
        label4.textColor = [UIColor whiteColor];
        label4.text = @"放弃到期返现奖励";
        label4.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];
        label4.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:titleLabel];
        [self addSubview:lineView2];
        [self addSubview:lineView1];
        [self addSubview:label1];
        [self addSubview:label2];
        [self addSubview:label3];
        [self addSubview:label4];
        [self addSubview:confirmButton];
        [self addSubview:cancelButton];
        
        self.alpha = 0;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    }
    
    return self;
}

- (void)showView
{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:0.3f];
    self.alpha = 1;
    self.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)confirm:(id)sender
{
    [self performSelector:@selector(blockAction) withObject:nil afterDelay:0];
}

- (void)cancel:(id)sender
{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:0.2];
    [self setAlpha:0];
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)blockAction
{
    if (self.block)
    {
        self.block(nil);
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.2];
        [self setAlpha:0];
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
}

@end
