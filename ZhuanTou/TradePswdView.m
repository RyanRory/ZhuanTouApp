//
//  TradePswdView.m
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/20.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "TradePswdView.h"

@implementation TradePswdView

@synthesize centerView, titleLabel, hiddenTextField, cancelButton, lineView, textField1, textField2, textField3, textField4,textField5, textField6;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        centerView = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width-280)/2, (frame.size.height-351)/2, 280, 136)];
        centerView.backgroundColor = [UIColor whiteColor];
        centerView.clipsToBounds = YES;
        centerView.layer.cornerRadius = 20;
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 280, 30)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"请输入交易密码";
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        hiddenTextField = [[UITextField alloc]init];
        hiddenTextField.alpha = 0;
        hiddenTextField.keyboardType = UIKeyboardTypeNumberPad;
        [hiddenTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 96, 280, 40)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 95, 280, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        
        textField1 = [[UITextField alloc]initWithFrame:CGRectMake(15, 50, 35, 35)];
        textField1.secureTextEntry = YES;
        textField1.borderStyle = UITextBorderStyleLine;
        textField1.textAlignment = NSTextAlignmentCenter;
        textField1.font = [UIFont systemFontOfSize:20];
        textField2 = [[UITextField alloc]initWithFrame:CGRectMake(58, 50, 35, 35)];
        textField2.secureTextEntry = YES;
        textField2.borderStyle = UITextBorderStyleLine;
        textField2.textAlignment = NSTextAlignmentCenter;
        textField2.font = [UIFont systemFontOfSize:20];
        textField3 = [[UITextField alloc]initWithFrame:CGRectMake(101, 50, 35, 35)];
        textField3.secureTextEntry = YES;
        textField3.borderStyle = UITextBorderStyleLine;
        textField3.textAlignment = NSTextAlignmentCenter;
        textField3.font = [UIFont systemFontOfSize:20];
        textField4 = [[UITextField alloc]initWithFrame:CGRectMake(144, 50, 35, 35)];
        textField4.secureTextEntry = YES;
        textField4.borderStyle = UITextBorderStyleLine;
        textField4.textAlignment = NSTextAlignmentCenter;
        textField4.font = [UIFont systemFontOfSize:20];
        textField5 = [[UITextField alloc]initWithFrame:CGRectMake(187, 50, 35, 35)];
        textField5.secureTextEntry = YES;
        textField5.borderStyle = UITextBorderStyleLine;
        textField5.textAlignment = NSTextAlignmentCenter;
        textField5.font = [UIFont systemFontOfSize:20];
        textField6 = [[UITextField alloc]initWithFrame:CGRectMake(230, 50, 35, 35)];
        textField6.secureTextEntry = YES;
        textField6.borderStyle = UITextBorderStyleLine;
        textField6.textAlignment = NSTextAlignmentCenter;
        textField6.font = [UIFont systemFontOfSize:20];
        
        [centerView addSubview:titleLabel];
        [centerView addSubview:hiddenTextField];
        [centerView addSubview:textField1];
        [centerView addSubview:textField2];
        [centerView addSubview:textField3];
        [centerView addSubview:textField4];
        [centerView addSubview:textField5];
        [centerView addSubview:textField6];
        [centerView addSubview:lineView];
        [centerView addSubview:cancelButton];
        
        [self addSubview:centerView];
        self.alpha = 0;
        centerView.alpha = 0;
        centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    }
    return self;
}

- (void)showView
{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:0.2f];
    self.alpha = 1;
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:0.3f];
    centerView.alpha = 1;
    centerView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hiddenTextField becomeFirstResponder];
    });
}

- (void)textFieldEditingChanged:(UITextField*)sender
{
    NSMutableString *str = [NSMutableString stringWithString:sender.text];
    if (str.length > 0)
    {
        textField1.text = [str substringWithRange:NSMakeRange(0, 1)];
        if (str.length > 1)
        {
            textField2.text = [str substringWithRange:NSMakeRange(1, 1)];
            if (str.length > 2)
            {
                textField3.text = [str substringWithRange:NSMakeRange(2, 1)];
                if (str.length > 3)
                {
                    textField4.text = [str substringWithRange:NSMakeRange(3, 1)];
                    if (str.length > 4)
                    {
                        textField5.text = [str substringWithRange:NSMakeRange(4, 1)];
                        if (str.length > 5)
                        {
                            textField6.text = [str substringWithRange:NSMakeRange(5, 1)];
                            [self performSelector:@selector(blockAction:) withObject:str afterDelay:0];
                        }
                    }
                }
            }
        }
    }
}

- (void)cancel:(id)sender
{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:0.2];
    [self setAlpha:0];
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hiddenTextField resignFirstResponder];
        [self removeFromSuperview];
    });
}

- (void)blockAction:(NSString *)resultStr
{
    if (self.block)
    {
        self.block(resultStr);
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.2];
        [self setAlpha:0];
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hiddenTextField resignFirstResponder];
            [self removeFromSuperview];
        });
    }
}


@end
