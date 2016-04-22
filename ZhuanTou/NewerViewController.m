//
//  NewerViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/8.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "NewerViewController.h"

@interface NewerViewController ()

@end

@implementation NewerViewController

@synthesize registerView, registerButton, registerDescriptionLabel, registerImage, registerLabel, registerHand, registerBlueHand, registerLight, registerContentView, toRegisterButton, registerBonus, registerBounsImageView, registerBonusOpenedImageView, registerBonusButton;
@synthesize secureView, secureButton, secureDescriptionLabel, secureImage, secureLabel, secureLine, secureHand, secureBlueHand, secureLight, secureContentView, secureConfirmButton, realNameTextField, idCardNoTextField, tradePswdAgainTextField, tradePswdTextField;
@synthesize chargeView, chargeButton, chargeDescriptionLabel, chargeImage, chargeLabel, chargeLine, chargeHand, chargeBlueHand, chargeLight, chargeContentView, wenjianDetailButton, zongheDetailButton, toChargeButton, chargeWenjianView, chargeZongheView;
@synthesize investView, investButton, investDescriptionLabel, investImage, investLabel, investLine, investHand, investBlueHand, investLight, investContentView, backLine, toBuyWenjian, toBuyZonghe, investZongheView, investWenjianView, investBonus, investBonusButton, investBonusImageView, investBonusOpenedImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    status = 0;
    bonus1 = false;
    bonus2 = false;
    
    registerLight.hidden = YES;
    registerBlueHand.hidden = YES;
    secureLight.hidden = YES;
    secureBlueHand.hidden = YES;
    chargeLight.hidden = YES;
    chargeBlueHand.hidden = YES;
    investLight.hidden = YES;
    investBlueHand.hidden = YES;
    
    registerHand.hidden = YES;
    secureHand.hidden = YES;
    chargeHand.hidden = YES;
    investHand.hidden = YES;
    
    registerContentView.hidden = YES;
    secureContentView.hidden = YES;
    chargeContentView.hidden = YES;
    investContentView.hidden = YES;
    
    [chargeZongheView.layer setBorderColor:ZTBLUE.CGColor];
    [chargeWenjianView.layer setBorderColor:ZTLIGHTRED.CGColor];
    [investZongheView.layer setBorderColor:ZTBLUE.CGColor];
    [investWenjianView.layer setBorderColor:ZTLIGHTRED.CGColor];
    
    [registerButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [secureButton addTarget:self action:@selector(clickSecureButton:) forControlEvents:UIControlEventTouchUpInside];
    [chargeButton addTarget:self action:@selector(clickChargeButton:) forControlEvents:UIControlEventTouchUpInside];
    [investButton addTarget:self action:@selector(clickInvestButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [toRegisterButton addTarget:self action:@selector(toRegister:) forControlEvents:UIControlEventTouchUpInside];
    [secureConfirmButton addTarget:self action:@selector(secureConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [toChargeButton addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
    [wenjianDetailButton addTarget:self action:@selector(toWenjianDetail:) forControlEvents:UIControlEventTouchUpInside];
    [zongheDetailButton addTarget:self action:@selector(toZongheDetail:) forControlEvents:UIControlEventTouchUpInside];
    [toBuyWenjian addTarget:self action:@selector(toBuyWenjian:) forControlEvents:UIControlEventTouchUpInside];
    [toBuyZonghe addTarget:self action:@selector(toBuyZonghe:) forControlEvents:UIControlEventTouchUpInside];
    
    [registerBonusButton setUserInteractionEnabled:NO];
    [registerBonusButton addTarget:self action:@selector(openRegisterBonus:) forControlEvents:UIControlEventTouchUpInside];
    registerBonusOpenedImageView.hidden = YES;
    [investBonusButton setUserInteractionEnabled:NO];
    [investBonusButton addTarget:self action:@selector(openInvestBonus:) forControlEvents:UIControlEventTouchUpInside];
    investBonusOpenedImageView.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/freshmanStatus"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        [hud hide:YES];
        if (![NSString stringWithFormat:@"%@", [responseObject objectForKey:@"registered"]].boolValue)
        {
            status = 0;
            [registerButton setUserInteractionEnabled:YES];
            [secureButton setUserInteractionEnabled:NO];
            [chargeButton setUserInteractionEnabled:NO];
            [investButton setUserInteractionEnabled:NO];
            
            if (registerContentView.hidden)
            {
                registerBlueHand.hidden = NO;
                blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:registerBlueHand, registerLight, nil] repeats:YES];
            }

        }
        else if (![NSString stringWithFormat:@"%@", [responseObject objectForKey:@"realnameSettled"]].boolValue)
        {
            status = 1;
            [registerButton setUserInteractionEnabled:NO];
            [secureButton setUserInteractionEnabled:YES];
            [chargeButton setUserInteractionEnabled:NO];
            [investButton setUserInteractionEnabled:NO];
            
            registerImage.image = [UIImage imageNamed:@"newerRegisterBlue.png"];
            registerLabel.textColor = ZTBLUE;
            registerDescriptionLabel.textColor = ZTBLUE;
            
            if (secureContentView.hidden)
            {
                secureBlueHand.hidden = NO;
                blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:secureBlueHand, secureLight, nil] repeats:YES];
            }
            
            if (!registerContentView.hidden)
            {
                registerButton.selected = !registerButton.selected;
                registerHand.hidden = YES;
                [self transPosition:secureView moveY:0 duration:0];
                [self transPosition:chargeView moveY:0 duration:0];
                registerContentView.hidden = YES;
            }
            
            bonus1 = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"freshman10Got"]].boolValue;
            if (!bonus1)
            {
                shakeTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(shake:) userInfo:registerBonus repeats:YES];
                registerBounsImageView.image = [UIImage imageNamed:@"newerBonusRed.png"];
                registerBonusOpenedImageView.hidden = YES;
                [registerBonusButton setUserInteractionEnabled:YES];
            }
            else
            {
                registerBounsImageView.hidden = YES;
                registerBonusOpenedImageView.hidden = NO;
                [registerBonus.layer removeAllAnimations];
            }

        }
        else if (![NSString stringWithFormat:@"%@", [responseObject objectForKey:@"charged"]].boolValue)
        {
            [registerButton setUserInteractionEnabled:NO];
            [secureButton setUserInteractionEnabled:NO];
            [chargeButton setUserInteractionEnabled:YES];
            [investButton setUserInteractionEnabled:NO];
            
            registerImage.image = [UIImage imageNamed:@"newerRegisterBlue.png"];
            registerLabel.textColor = ZTBLUE;
            registerDescriptionLabel.textColor = ZTBLUE;
            
            secureImage.image = [UIImage imageNamed:@"newerSecureBlue.png"];
            secureLabel.textColor = ZTBLUE;
            secureDescriptionLabel.textColor = ZTBLUE;
            secureLine.backgroundColor = ZTBLUE;
            
            if (chargeContentView.hidden)
            {
                chargeBlueHand.hidden = NO;
                blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:chargeBlueHand, chargeLight, nil] repeats:YES];
            }
            
            if (!secureContentView.hidden)
            {
                secureButton.selected = !secureButton.selected;
                secureHand.hidden = YES;
                [self transPosition:chargeView moveY:0 duration:0];
                [self transPosition:secureView moveY:0 duration:0];
                secureContentView.transform = CGAffineTransformMakeTranslation(0, (secureViewFrame.size.height-82));
                secureContentView.hidden = YES;
            }
            
            bonus1 = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"freshman10Got"]].boolValue;
            if (!bonus1)
            {
                shakeTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(shake:) userInfo:registerBonus repeats:YES];
                registerBounsImageView.image = [UIImage imageNamed:@"newerBonusRed.png"];
                registerBonusOpenedImageView.hidden = YES;
                [registerBonusButton setUserInteractionEnabled:YES];
            }
            else
            {
                registerBounsImageView.hidden = YES;
                registerBonusOpenedImageView.hidden = NO;
                [registerBonus.layer removeAllAnimations];
            }
        }
        else if (![NSString stringWithFormat:@"%@", [responseObject objectForKey:@"investorAchieved"]].boolValue)
        {
            status = 3;
            [registerButton setUserInteractionEnabled:NO];
            [secureButton setUserInteractionEnabled:NO];
            [chargeButton setUserInteractionEnabled:NO];
            [investButton setUserInteractionEnabled:YES];
            
            registerImage.image = [UIImage imageNamed:@"newerRegisterBlue.png"];
            registerLabel.textColor = ZTBLUE;
            registerDescriptionLabel.textColor = ZTBLUE;
            
            secureImage.image = [UIImage imageNamed:@"newerSecureBlue.png"];
            secureLabel.textColor = ZTBLUE;
            secureDescriptionLabel.textColor = ZTBLUE;
            secureLine.backgroundColor = ZTBLUE;
            
            chargeImage.image = [UIImage imageNamed:@"newerChargeBlue.png"];
            chargeLabel.textColor = ZTBLUE;
            chargeDescriptionLabel.textColor = ZTBLUE;
            chargeLine.backgroundColor = ZTBLUE;
            
            if (investContentView.hidden)
            {
                investBlueHand.hidden = NO;
                blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:investBlueHand, investLight, nil] repeats:YES];
            }
            
            if (!chargeContentView.hidden)
            {
                chargeButton.selected = !chargeButton.selected;
                chargeHand.hidden = YES;
                [self transPosition:chargeView moveY:0 duration:0];
                [self transPosition:secureView moveY:0 duration:0];
                chargeContentView.transform = CGAffineTransformMakeTranslation(0, 2*(secureViewFrame.size.height-82));
                chargeContentView.hidden = YES;
            }
            
            bonus1 = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"freshman10Got"]].boolValue;
            if (!bonus1)
            {
                shakeTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(shake:) userInfo:registerBonus repeats:YES];
                registerBounsImageView.image = [UIImage imageNamed:@"newerBonusRed.png"];
                registerBonusOpenedImageView.hidden = YES;
                [registerBonusButton setUserInteractionEnabled:YES];
            }
            else
            {
                registerBounsImageView.hidden = YES;
                registerBonusOpenedImageView.hidden = NO;
                [registerBonus.layer removeAllAnimations];
            }

        }
        else
        {
            status = 4;
            [registerButton setUserInteractionEnabled:NO];
            [secureButton setUserInteractionEnabled:NO];
            [chargeButton setUserInteractionEnabled:NO];
            [investButton setUserInteractionEnabled:NO];
            
            registerImage.image = [UIImage imageNamed:@"newerRegisterBlue.png"];
            registerLabel.textColor = ZTBLUE;
            registerDescriptionLabel.textColor = ZTBLUE;
            
            secureImage.image = [UIImage imageNamed:@"newerSecureBlue.png"];
            secureLabel.textColor = ZTBLUE;
            secureDescriptionLabel.textColor = ZTBLUE;
            secureLine.backgroundColor = ZTBLUE;
            
            chargeImage.image = [UIImage imageNamed:@"newerChargeBlue.png"];
            chargeLabel.textColor = ZTBLUE;
            chargeDescriptionLabel.textColor = ZTBLUE;
            chargeLine.backgroundColor = ZTBLUE;
            
            investImage.image = [UIImage imageNamed:@"newerInvestBlue.png"];
            investLabel.textColor = ZTBLUE;
            investDescriptionLabel.textColor = ZTBLUE;
            investLine.backgroundColor = ZTBLUE;
            
            if (!investContentView.hidden)
            {
                investButton.selected = !investButton.selected;
                investHand.hidden = YES;
                [self transPosition:investBonus moveY:0 duration:0];
                [self transPosition:investView moveY:0 duration:0];
                [self transPosition:chargeView moveY:0 duration:0];
                [self transPosition:secureView moveY:0 duration:0];
                backLine.hidden = NO;
                investContentView.transform = CGAffineTransformMakeTranslation(0, 3*(secureViewFrame.size.height-82));
                investContentView.hidden = YES;
            }
            
            bonus1 = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"freshman10Got"]].boolValue;
            if (!bonus1)
            {
                shakeTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(shake:) userInfo:registerBonus repeats:YES];
                registerBounsImageView.image = [UIImage imageNamed:@"newerBonusRed.png"];
                registerBonusOpenedImageView.hidden = YES;
                [registerBonusButton setUserInteractionEnabled:YES];
            }
            else
            {
                registerBounsImageView.hidden = YES;
                registerBonusOpenedImageView.hidden = NO;
                [registerBonus.layer removeAllAnimations];
            }
            
            bonus2 = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"freshman50Got"]].boolValue;
            if (!bonus2)
            {
                shakeTimer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(shake:) userInfo:investBonus repeats:YES];
                investBonusOpenedImageView.hidden = YES;
                investBonusImageView.image = [UIImage imageNamed:@"newerBonusRed.png"];
                [investBonusButton setUserInteractionEnabled:YES];
            }
            else
            {
                investBonusImageView.hidden = YES;
                investBonusOpenedImageView.hidden = NO;
                [investBonus.layer removeAllAnimations];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    switch (status) {
        case 0:
            blueHandFrame = registerBlueHand.frame;
            break;
            
        case 1:
            blueHandFrame = secureBlueHand.frame;
            break;
            
        case 2:
            blueHandFrame = chargeBlueHand.frame;
            break;
            
        case 3:
            blueHandFrame = investBlueHand.frame;
            break;
            
        default:
            break;
    }
    secureViewFrame = secureView.frame;
    chargeViewFrame = chargeView.frame;
    investViewFrame = investView.frame;
    [secureConfirmButton setUserInteractionEnabled:NO];
    [secureConfirmButton setAlpha:0.6];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [blueHandTimer invalidate];
    [shakeTimer invalidate];
    [shakeTimer1 invalidate];
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickRegisterButton:(id)sender
{
    registerButton.selected = !registerButton.selected;
    if (registerButton.selected)
    {
        registerBlueHand.hidden = YES;
        registerLight.alpha = 0;
        [blueHandTimer invalidate];
        [self transPosition:chargeView moveY:investViewFrame.size.height-82 duration:0.2];
        [self transPosition:secureView moveY:2*(investViewFrame.size.height-82) duration:0.4];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            registerHand.hidden = NO;
            CABasicAnimation *anima=[CABasicAnimation animation];
            anima.keyPath=@"transform.translation.x";
            anima.toValue=[NSNumber numberWithDouble:10];
            anima.removedOnCompletion=NO;
            anima.fillMode=kCAFillModeForwards;
            anima.duration = 0.5;
            [registerHand.layer addAnimation:anima forKey:nil];
            registerContentView.alpha = 0;
            registerContentView.hidden = NO;
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationDuration:0.5f];
            registerContentView.alpha = 1;
            [UIView commitAnimations];
        });
    }
    else
    {
        registerHand.hidden = YES;
        [registerHand.layer removeAllAnimations];
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.2f];
        registerContentView.alpha = 0;
        [UIView commitAnimations];
        [self transPosition:secureView moveY:0 duration:0.4];
        [self transPosition:chargeView moveY:0 duration:0.2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            registerBlueHand.hidden = NO;
            registerLight.hidden = YES;
            registerLight.alpha = 1;
            registerContentView.hidden = YES;
            blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:registerBlueHand, registerLight, nil] repeats:YES];
        });
    }
}

- (void)clickSecureButton:(id)sender
{
    [realNameTextField resignFirstResponder];
    [idCardNoTextField resignFirstResponder];
    [tradePswdTextField resignFirstResponder];
    [tradePswdAgainTextField resignFirstResponder];
    
    secureButton.selected = !secureButton.selected;
    if (secureButton.selected)
    {
        secureBlueHand.hidden = YES;
        secureLight.alpha = 0;
        [blueHandTimer invalidate];
        [self transPosition:chargeView moveY:investViewFrame.size.height-82 duration:0.2];
        [self transPosition:secureView moveY:-(secureViewFrame.size.height-82) duration:0.2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            secureHand.hidden = NO;
            CABasicAnimation *anima=[CABasicAnimation animation];
            anima.keyPath=@"transform.translation.x";
            anima.toValue=[NSNumber numberWithDouble:10];
            anima.removedOnCompletion=NO;
            anima.fillMode=kCAFillModeForwards;
            anima.duration = 0.5;
            [secureHand.layer addAnimation:anima forKey:nil];
            secureContentView.transform = CGAffineTransformMakeTranslation(0, -(secureViewFrame.size.height-82));
            secureContentView.alpha = 0;
            secureContentView.hidden = NO;
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationDuration:0.5f];
            secureContentView.alpha = 1;
            [UIView commitAnimations];
        });

    }
    else
    {
        secureHand.hidden = YES;
        [secureHand.layer removeAllAnimations];
        [self transPosition:chargeView moveY:0 duration:0.2];
        [self transPosition:secureView moveY:0 duration:0.2];
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.2f];
        secureContentView.alpha = 0;
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            secureContentView.transform = CGAffineTransformMakeTranslation(0, (secureViewFrame.size.height-82));
            secureBlueHand.hidden = NO;
            secureLight.hidden = YES;
            secureLight.alpha = 1;
            secureContentView.hidden = YES;
            blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:secureBlueHand, secureLight, nil] repeats:YES];
        });
    }
}

- (void)clickChargeButton:(id)sender
{
    chargeButton.selected = !chargeButton.selected;
    if (chargeButton.selected)
    {
        chargeBlueHand.hidden = YES;
        chargeLight.alpha = 0;
        [blueHandTimer invalidate];
        [self transPosition:chargeView moveY:-2*(secureViewFrame.size.height-82) duration:0.4];
        [self transPosition:secureView moveY:-(secureViewFrame.size.height-82) duration:0.2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            chargeHand.hidden = NO;
            CABasicAnimation *anima=[CABasicAnimation animation];
            anima.keyPath=@"transform.translation.x";
            anima.toValue=[NSNumber numberWithDouble:10];
            anima.removedOnCompletion=NO;
            anima.fillMode=kCAFillModeForwards;
            anima.duration = 0.5;
            [chargeHand.layer addAnimation:anima forKey:nil];
            chargeContentView.transform = CGAffineTransformMakeTranslation(0, -2*(secureViewFrame.size.height-82));
            chargeContentView.alpha = 0;
            chargeContentView.hidden = NO;
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationDuration:0.5f];
            chargeContentView.alpha = 1;
            [UIView commitAnimations];
        });
        
    }
    else
    {
        chargeHand.hidden = YES;
        [chargeHand.layer removeAllAnimations];
        [self transPosition:chargeView moveY:0 duration:0.4];
        [self transPosition:secureView moveY:0 duration:0.2];
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.2f];
        chargeContentView.alpha = 0;
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            chargeContentView.transform = CGAffineTransformMakeTranslation(0, 2*(secureViewFrame.size.height-82));
            chargeBlueHand.hidden = NO;
            chargeLight.hidden = YES;
            chargeLight.alpha = 1;
            chargeContentView.hidden = YES;
            blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:chargeBlueHand, chargeLight, nil] repeats:YES];
        });
    }

}

- (void)clickInvestButton:(id)sender
{
    investButton.selected = !investButton.selected;
    if (investButton.selected)
    {
        investBlueHand.hidden = YES;
        investLight.alpha = 0;
        [blueHandTimer invalidate];
        backLine.hidden = YES;
        [self transPosition:investBonus moveY:-3*(secureViewFrame.size.height-82) duration:0.6];
        [self transPosition:investView moveY:-3*(secureViewFrame.size.height-82) duration:0.6];
        [self transPosition:chargeView moveY:-2*(secureViewFrame.size.height-82) duration:0.4];
        [self transPosition:secureView moveY:-(secureViewFrame.size.height-82) duration:0.2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            investHand.hidden = NO;
            CABasicAnimation *anima=[CABasicAnimation animation];
            anima.keyPath=@"transform.translation.x";
            anima.toValue=[NSNumber numberWithDouble:10];
            anima.removedOnCompletion=NO;
            anima.fillMode=kCAFillModeForwards;
            anima.duration = 0.5;
            [investHand.layer addAnimation:anima forKey:nil];
            investContentView.transform = CGAffineTransformMakeTranslation(0, -3*(secureViewFrame.size.height-82));
            investContentView.alpha = 0;
            investContentView.hidden = NO;
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationDuration:0.5f];
            investContentView.alpha = 1;
            [UIView commitAnimations];
        });
        
    }
    else
    {
        investHand.hidden = YES;
        [investHand.layer removeAllAnimations];
        [self transPosition:investBonus moveY:0 duration:0.6];
        [self transPosition:investView moveY:0 duration:0.6];
        [self transPosition:chargeView moveY:0 duration:0.4];
        [self transPosition:secureView moveY:0 duration:0.2];
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.2f];
        investContentView.alpha = 0;
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            backLine.hidden = NO;
            investContentView.transform = CGAffineTransformMakeTranslation(0, 3*(secureViewFrame.size.height-82));
            investBlueHand.hidden = NO;
            investLight.hidden = YES;
            investLight.alpha = 1;
            investContentView.hidden = YES;
            blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:investBlueHand, investLight, nil] repeats:YES];
        });
    }

}


- (void)toRegister:(id)sender
{
    RegisterViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    vc.isFromNewer = true;
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)secureConfirm:(id)sender
{
    isHttpFinished = 0;
    [realNameTextField resignFirstResponder];
    [idCardNoTextField resignFirstResponder];
    [tradePswdTextField resignFirstResponder];
    [tradePswdAgainTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:hud];
    NSString *idReg = @"^[0-9]{17}[0-9X]$";
    NSPredicate *regextestId = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idReg];
    
    NSString *PasswordReg = @"^[0-9]{6}$";
    NSPredicate *regextestpassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PasswordReg];
    
    NSArray *weights = [[NSArray alloc]initWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSArray *partityBits = [[NSArray alloc]initWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil];
    int power = 0;
    const char *chars = [idCardNoTextField.text cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i=0; i<17; i++)
    {
        power += ((int)chars[i]-48) * ((NSString*)weights[i]).intValue;
    }
    
    if((![regextestId evaluateWithObject: idCardNoTextField.text]) || !([(NSString*)partityBits[power%11] isEqualToString:[NSString stringWithCString:&chars[17] encoding:NSUTF8StringEncoding]]))
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请检查您的身份证号码是否正确";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [idCardNoTextField becomeFirstResponder];
        });
    }
    else if(![tradePswdTextField.text isEqualToString: tradePswdAgainTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"两次输入的密码不一致";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tradePswdAgainTextField becomeFirstResponder];
        });
    }
    else if(![regextestpassword evaluateWithObject: tradePswdTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"密码至少8位，包括数字和字母";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tradePswdTextField becomeFirstResponder];
        });
    }
    else
    {
        [secureConfirmButton setUserInteractionEnabled:NO];
        [secureConfirmButton setAlpha:0.6f];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/setIdCard/%@/%@", idCardNoTextField.text, [realNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            isHttpFinished ++;
            NSString *str = [responseObject objectForKey:@"isSuccess"];
            int f1 = str.intValue;
            if (f1 == 0)
            {
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = [responseObject objectForKey:@"errorMessage"];
                [hud hide:YES afterDelay:1.5f];
            }
            else
            {
                if (isHttpFinished == 2)
                {
                    secureImage.image = [UIImage imageNamed:@"newerSecureBlue.png"];
                    secureLabel.textColor = ZTBLUE;
                    secureDescriptionLabel.textColor = ZTBLUE;
                    secureLine.backgroundColor = ZTBLUE;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        chargeBlueHand.hidden = NO;
                        blueHandFrame = chargeBlueHand.frame;
                        blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:chargeBlueHand, chargeLight, nil] repeats:YES];
                    });
                    secureButton.selected = !secureButton.selected;
                    secureHand.hidden = YES;
                    [self transPosition:chargeView moveY:0 duration:0.2];
                    [self transPosition:secureView moveY:0 duration:0.2];
                    secureContentView.transform = CGAffineTransformMakeTranslation(0, (secureViewFrame.size.height-82));
                    secureContentView.hidden = YES;
                    [secureButton setUserInteractionEnabled:NO];
                    [chargeButton setUserInteractionEnabled:YES];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
            
            isHttpFinished ++;
            if (isHttpFinished == 2)
            {
                [secureConfirmButton setUserInteractionEnabled:YES];
                [secureConfirmButton setAlpha:1.0f];
            }
        }];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"tradePassword":tradePswdTextField.text,
                                     @"loginPassword":[userDefault objectForKey:PASSWORD]};
        NSString *URL1 = [BASEURL stringByAppendingString:@"api/account/setTradePassword"];
        [manager1 POST:URL1 parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            isHttpFinished ++;
            NSString *str = [responseObject objectForKey:@"isSuccess"];
            int f1 = str.intValue;
            if (f1 == 0)
            {
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = [responseObject objectForKey:@"errorMessage"];
                [hud hide:YES afterDelay:1.5f];
            }
            else
            {
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"设置成功";
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setBool:true forKey:ISTRADEPSWDSET];
                [userDefault synchronize];
                [hud hide:YES afterDelay:1.5f];
                if (isHttpFinished == 2)
                {
                    secureImage.image = [UIImage imageNamed:@"newerSecureBlue.png"];
                    secureLabel.textColor = ZTBLUE;
                    secureDescriptionLabel.textColor = ZTBLUE;
                    secureLine.backgroundColor = ZTBLUE;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        chargeBlueHand.hidden = NO;
                        blueHandFrame = chargeBlueHand.frame;
                        blueHandTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(blueHandAnimation:) userInfo:[NSArray arrayWithObjects:chargeBlueHand, chargeLight, nil] repeats:YES];
                    });
                    secureButton.selected = !secureButton.selected;
                    secureHand.hidden = YES;
                    [self transPosition:chargeView moveY:0 duration:0.2];
                    [self transPosition:secureView moveY:0 duration:0.2];
                    secureContentView.transform = CGAffineTransformMakeTranslation(0, (secureViewFrame.size.height-82));
                    secureContentView.hidden = YES;
                    [secureButton setUserInteractionEnabled:NO];
                    [chargeButton setUserInteractionEnabled:YES];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
            
            isHttpFinished ++;
            if (isHttpFinished == 2)
            {
                [secureConfirmButton setUserInteractionEnabled:YES];
                [secureConfirmButton setAlpha:1.0f];
            }
        }];

    }

}

- (void)toCharge:(id)sender
{
    ChargeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ChargeViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toWenjianDetail:(id)sender
{
    WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
    vc.title = @"稳盈宝";
    [vc setURL:[BASEURL stringByAppendingString:@"Mobile/Home/WenDesc"]];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toZongheDetail:(id)sender
{
    WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
    vc.title = @"分红宝";
    [vc setURL:[BASEURL stringByAppendingString:@"Mobile/Home/FenDesc"]];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toBuyWenjian:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/0"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        [hud hide:YES];
        ProductBuyNewViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyViewController"];
        vc.style = WENJIAN;
        vc.isFromNewer = true;
        vc.productInfo = responseObject;
        vc.idOrCode = [responseObject objectForKey:@"id"];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00"];
        vc.bidableAmount = [NSString stringWithString:[formatter stringFromNumber:[responseObject objectForKey:@"bidableAmount"]]];
        [[self navigationController] pushViewController:vc animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)toBuyZonghe:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/1"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        [hud hide:YES];
        ProductBuyNewViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyViewController"];
        vc.style = ZONGHE;
        vc.isFromNewer = true;
        vc.productInfo = responseObject;
        vc.idOrCode = [responseObject objectForKey:@"id"];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00"];
        vc.bidableAmount = [NSString stringWithString:[formatter stringFromNumber:[responseObject objectForKey:@"bidableAmount"]]];
        [[self navigationController] pushViewController:vc animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)openRegisterBonus:(id)sender
{
    [shakeTimer invalidate];
    [registerBonus.layer removeAllAnimations];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/drawCoupon/FRESHMAN10"];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if ([NSString stringWithFormat:@"%@", [responseObject objectForKey:@"isSuccess"]].boolValue)
        {
            registerBonusOpenedImageView.hidden = NO;
            registerBounsImageView.hidden = YES;
            [registerBonusButton setUserInteractionEnabled:NO];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"红包领取成功";
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [responseObject objectForKey:@"errorMessage"];
            [hud hide:YES afterDelay:1.5f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)openInvestBonus:(id)sender
{
    [shakeTimer1 invalidate];
    [investBonus.layer removeAllAnimations];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/drawCoupon/FRESHMAN666"];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if ([NSString stringWithFormat:@"%@", [responseObject objectForKey:@"isSuccess"]].boolValue)
        {
            investBonusOpenedImageView.hidden = NO;
            investBonusImageView.hidden = YES;
            [investBonusButton setUserInteractionEnabled:NO];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"红包领取成功";
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [responseObject objectForKey:@"errorMessage"];
            [hud hide:YES afterDelay:1.5f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)blueHandAnimation:(NSTimer*) timer
{
    
    UIImageView *hand = [[NSArray arrayWithArray:[timer userInfo]] objectAtIndex:0];
    UIImageView *light = [[NSArray arrayWithArray:[timer userInfo]] objectAtIndex:1];
    light.hidden = YES;
    [hand setFrame:blueHandFrame];
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:0.5];
    [hand setFrame:CGRectMake(blueHandFrame.origin.x+10, blueHandFrame.origin.y, blueHandFrame.size.width, blueHandFrame.size.height)];
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        light.hidden = NO;
    });
}

- (void)transPosition:(UIView *)view moveY:(double)y duration:(double)t
{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:t];
    view.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
}

- (void)shake:(NSTimer*)timer
{
    UIView *myView = [timer userInfo];
    int offset = 5;
    
    CALayer *lbl = [myView layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-offset, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+offset, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.06];
    [animation setRepeatCount:2];
    [lbl addAnimation:animation forKey:nil];
}

- (IBAction)textFiledReturnEditing:(id)sender
{
    if (sender == realNameTextField)
    {
        [realNameTextField resignFirstResponder];
        [idCardNoTextField becomeFirstResponder];
    }
    else if (sender == idCardNoTextField)
    {
        [idCardNoTextField resignFirstResponder];
        [tradePswdTextField becomeFirstResponder];
    }
    else if (sender == tradePswdTextField)
    {
        [tradePswdTextField resignFirstResponder];
        [tradePswdAgainTextField becomeFirstResponder];
    }
    else
    {
        [tradePswdAgainTextField resignFirstResponder];
    }
}

- (IBAction)backgroundTap:(id)sender
{
    [realNameTextField resignFirstResponder];
    [idCardNoTextField resignFirstResponder];
    [tradePswdTextField resignFirstResponder];
    [tradePswdAgainTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((realNameTextField.text.length > 0) && (idCardNoTextField.text.length > 0) && (tradePswdTextField.text.length > 0) && (tradePswdAgainTextField.text.length > 0))
    {
        [secureConfirmButton setUserInteractionEnabled:YES];
        [secureConfirmButton setAlpha:1];
    }
    else
    {
        [secureConfirmButton setUserInteractionEnabled:NO];
        [secureConfirmButton setAlpha:0.6];
    }
}

@end
