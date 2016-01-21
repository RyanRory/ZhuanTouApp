//
//  ProductBuyNewViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/20.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductBuyNewViewController.h"

@interface ProductBuyNewViewController ()

@end

@implementation ProductBuyNewViewController

@synthesize amountTextField, confirmButton, checkboxButton, agreementButton, chargeButton, balanceLabel, restLabel;
@synthesize style, idOrCode, productInfo, bidableAmount;
@synthesize bonusBgView, bonusButton, bonusDDLLabel, bonusLimitLabel, bonusMoreButton, bonusNumLabel, bonusView;
@synthesize couponsBgView, couponsButton, couponsDDLLabel, couponsLimitLabel, couponsMoreButton ,couponsNumLabel, couponsView;
@synthesize standingCouponsBgView, standingCouponsButton, standingCouponsDDLLabel, standingCouponsLimitLabel, standingCouponsMoreButton, standingCouponsNumLabel, standingCouponsView;
@synthesize label1, label2, buttonBottomLayOut;
@synthesize coupon, vouchers, biggestBonus, biggestCoupons, biggestStandingCoupons;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    
    checkboxButton.selected = YES;
    [checkboxButton addTarget:self action:@selector(checkboxEnsure:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [agreementButton addTarget:self action:@selector(toAgreemet:) forControlEvents:UIControlEventTouchUpInside];
    [chargeButton addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([style isEqualToString:WENJIAN])
    {
        self.title = @"购买稳盈宝";
        amountTextField.placeholder = @"100元起购，100元倍数递增";
        chargeButton.backgroundColor = ZTLIGHTRED;
        confirmButton.backgroundColor = ZTLIGHTRED;
    }
    else if ([style isEqualToString:ZONGHE])
    {
        self.title = @"购买分红宝";
        amountTextField.placeholder = @"100元起购，100元倍数递增";
        chargeButton.backgroundColor = ZTBLUE;
        confirmButton.backgroundColor = ZTBLUE;
    }
    else
    {
        self.title = @"转入专投宝";
        amountTextField.placeholder = @"请输入购买金额";
        chargeButton.backgroundColor = ZTRED;
        confirmButton.backgroundColor = ZTRED;
        bonusView.hidden = YES;
        couponsView.hidden = YES;
        standingCouponsView.hidden = YES;
        label1.hidden = YES;
        label2.hidden = YES;
        bonusMoreButton.hidden = YES;
        couponsMoreButton.hidden = YES;
        standingCouponsMoreButton.hidden = YES;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    NSLog(@"%@",bidableAmount);
    restLabel.text = [NSString stringWithFormat:@"可购份额(元)：%@万",[formatter stringFromNumber:[NSNumber numberWithDouble:bidableAmount.doubleValue/10000]]];
    
    SCNumberKeyBoard *keyboard = [SCNumberKeyBoard showWithTextField:amountTextField enter:nil close:nil];
    [keyboard.enterButton setBackgroundColor:ZTBLUE];
    [keyboard.enterButton setTitle:@"确定" forState:UIControlStateNormal];
    [keyboard.enterButton addTarget:self action:@selector(AIChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    bonusBgView.backgroundColor = ZTGRAY;
    couponsBgView.backgroundColor = ZTGRAY;
    standingCouponsBgView.backgroundColor = ZTGRAY;
    bonusDDLLabel.textColor = ZTGRAY;
    bonusLimitLabel.textColor = ZTGRAY;
    couponsDDLLabel.textColor = ZTGRAY;
    couponsLimitLabel.textColor = ZTGRAY;
    standingCouponsDDLLabel.textColor = ZTGRAY;
    standingCouponsLimitLabel.textColor = ZTGRAY;
    
    bonusMoreButton.hidden = YES;
    couponsMoreButton.hidden = YES;
    standingCouponsMoreButton.hidden = YES;
    
    bonusView.hidden = YES;
    couponsView.hidden = YES;
    standingCouponsView.hidden = YES;
    
    bonusButton.selected = NO;
    couponsButton.selected = NO;
    standingCouponsButton.selected = NO;
    
    [bonusButton addTarget:self action:@selector(chooseBonus:) forControlEvents:UIControlEventTouchUpInside];
    [couponsButton addTarget:self action:@selector(chooseCoupons:) forControlEvents:UIControlEventTouchUpInside];
    [standingCouponsButton addTarget:self action:@selector(chooseStandingCoupons:) forControlEvents:UIControlEventTouchUpInside];
    [bonusMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
    [couponsMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
    [standingCouponsMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
    
    coupon = @"";
    vouchers = @"";
    [self setupCoupons];
}

- (void)AIChoose:(id)sender
{
    [amountTextField resignFirstResponder];
    for (int i = 0; i<bonus.count; i++)
    {
        id data = [bonus objectAtIndex:i];
        if ((biggestBonus == nil) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"thresholdValue"]].intValue <= amountTextField.text.intValue))
        {
            biggestBonus = data;
        }
        else
        {
            if (([NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"money"]].intValue < [NSString stringWithFormat:@"%@",[data objectForKey:@"money"]].intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"thresholdValue"]].intValue <= amountTextField.text.intValue))
            {
                biggestBonus = data;
            }
        }
    }
    for (int i = 0; i<coupons.count; i++)
    {
        id data = [coupons objectAtIndex:i];
        if ((biggestCoupons == nil) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"threshold"]].intValue <= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue))
        {
            biggestCoupons = data;
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1 = [dateFormatter dateFromString:[biggestCoupons objectForKey:@"expireTime"]];
            NSDate *date2 = [dateFormatter dateFromString:[data objectForKey:@"expireTime"]];
            if (([date1 timeIntervalSinceDate:date2] < 0.0) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"threshold"]].intValue <= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue))
            {
                biggestCoupons = data;
            }
            else if (([date1 timeIntervalSinceDate:date2] == 0.0) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"threshold"]].intValue <= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"raiseRate"]].intValue < [NSString stringWithFormat:@"%@",[data objectForKey:@"raiseRate"]].intValue))
            {
                biggestCoupons = data;
            }
        }
    }
    for (int i = 0; i<standingCoupons.count; i++)
    {
        id data = [standingCoupons objectAtIndex:i];
        if ((biggestStandingCoupons == nil) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue))
        {
            biggestStandingCoupons = data;
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1 = [dateFormatter dateFromString:[biggestStandingCoupons objectForKey:@"expireTime"]];
            NSDate *date2 = [dateFormatter dateFromString:[data objectForKey:@"expireTime"]];
            if (([date1 timeIntervalSinceDate:date2] < 0.0)  && ([NSString stringWithFormat:@"%@",[data objectForKey:@"threshold"]].intValue <= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue))
            {
                biggestStandingCoupons = data;
            }
            else if (([date1 timeIntervalSinceDate:date2] == 0.0) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"threshold"]].intValue <= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"raiseRate"]].intValue < [NSString stringWithFormat:@"%@",[data objectForKey:@"raiseRate"]].intValue))
            {
                biggestStandingCoupons = data;
            }
        }
    }
}

- (void)chooseBonus:(id)sender
{
    if (!bonusButton.selected)
    {
        if (amountTextField.text.intValue >= [NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"thresholdValue"]].intValue)
        {
            bonusButton.selected = YES;
            bonusBgView.backgroundColor = ZTLIGHTRED;
            bonusDDLLabel.textColor = ZTLIGHTRED;
            bonusLimitLabel.textColor = ZTLIGHTRED;
            coupon = [NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"couponCode"]];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"投资金额满%@元可用",[biggestBonus objectForKey:@"thresholdValue"]];
            [hud hide:YES afterDelay:1.5];
        }
    }
    else
    {
        bonusButton.selected = NO;
        bonusBgView.backgroundColor = ZTGRAY;
        bonusDDLLabel.textColor = ZTGRAY;
        bonusLimitLabel.textColor = ZTGRAY;
        coupon = @"";
    }
}

- (void)toChooseBonusView:(UIButton*)sender
{
    ChooseBonusViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ChooseBonusViewController"];
    if (sender == bonusMoreButton)
    {
        vc.style = BONUS;
        vc.datas = [[NSMutableArray alloc]initWithArray:bonus];
        vc.choosen = biggestBonus;
    }
    else if (sender == couponsMoreButton)
    {
        vc.style = COUPONS;
        vc.datas = [[NSMutableArray alloc]initWithArray:coupons];
        vc.choosen = biggestCoupons;
    }
    else
    {
        vc.style = STANDINGCOUPONS;
        vc.datas = [[NSMutableArray alloc]initWithArray:standingCoupons];
        vc.choosen = biggestStandingCoupons;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if ([style isEqualToString:HUOQI])
    {
        buttonBottomLayOut.constant = 270;
    }
}

- (void)chooseCoupons:(id)sender
{
    if (!couponsButton.selected)
    {
        if (amountTextField.text.intValue > [NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"投资金额%d万元以下可用",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue/10000];
            [hud hide:YES afterDelay:1.5];
        }
        else if (amountTextField.text.intValue < [NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"threshold"]].intValue)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"投资金额%d元以上可用",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"threshold"]].intValue];
            [hud hide:YES afterDelay:1.5];
        }
        else
        {
            couponsButton.selected = YES;
            couponsBgView.backgroundColor = ZTBLUE;
            couponsDDLLabel.textColor = ZTBLUE;
            couponsLimitLabel.textColor = ZTBLUE;
            if (vouchers.length > 0)
            {
                vouchers = [vouchers stringByAppendingString:[NSString stringWithFormat:@",%@",[biggestCoupons objectForKey:@"voucherCode"]]];
            }
            else
            {
                vouchers = [biggestCoupons objectForKey:@"voucherCode"];
            }
        }
    }
    else
    {
        couponsButton.selected = NO;
        couponsBgView.backgroundColor = ZTGRAY;
        couponsDDLLabel.textColor = ZTGRAY;
        couponsLimitLabel.textColor = ZTGRAY;
        vouchers = [vouchers stringByReplacingOccurrencesOfString:[biggestCoupons objectForKey:@"voucherCode"] withString:@""];
        if (vouchers.length > 0)
        {
            if ([[vouchers substringFromIndex:(vouchers.length-1)] isEqualToString:@","])
            {
                vouchers = [vouchers substringToIndex:(vouchers.length-1)];
            }
        }
        
    }
}

- (void)chooseStandingCoupons:(id)sender
{
    if (!standingCouponsButton.selected)
    {
        if (amountTextField.text.intValue > [NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"principalLimit"]].intValue)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"投资金额%d万元以下可用",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"principalLimit"]].intValue/10000];
            [hud hide:YES afterDelay:1.5];
        }
        else if (amountTextField.text.intValue < [NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"threshold"]].intValue)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"投资金额%d元以上可用",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"threshold"]].intValue];
            [hud hide:YES afterDelay:1.5];
        }
        else
        {
            standingCouponsButton.selected = YES;
            standingCouponsBgView.backgroundColor = ZTBLUE;
            standingCouponsDDLLabel.textColor = ZTBLUE;
            standingCouponsLimitLabel.textColor = ZTBLUE;
            if (vouchers.length > 0)
            {
                vouchers = [vouchers stringByAppendingString:[NSString stringWithFormat:@",%@",[biggestStandingCoupons objectForKey:@"voucherCode"]]];
            }
            else
            {
                vouchers = [biggestCoupons objectForKey:@"voucherCode"];
            }
        }
    }
    else
    {
        standingCouponsButton.selected = NO;
        standingCouponsBgView.backgroundColor = ZTGRAY;
        standingCouponsDDLLabel.textColor = ZTGRAY;
        standingCouponsLimitLabel.textColor = ZTGRAY;
        vouchers = [vouchers stringByReplacingOccurrencesOfString:[biggestStandingCoupons objectForKey:@"voucherCode"] withString:@""];
        if (vouchers.length > 0)
        {
            if ([[vouchers substringFromIndex:(vouchers.length-1)] isEqualToString:@","])
            {
                vouchers = [vouchers substringToIndex:(vouchers.length-1)];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/couponInfo4M"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00"];
        if ([style isEqualToString:HUOQI])
        {
            balance = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"fundsAvailable"]].doubleValue;
            balanceLabel.text = [NSString stringWithFormat:@"可用余额(元)：%@",[formatter stringFromNumber:[responseObject objectForKey:@"fundsAvailable"]]];
        }
        else
        {
            balance = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"fundsAvailable"]].doubleValue + [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ztbBalance"]].doubleValue;
            balanceLabel.text = [NSString stringWithFormat:@"可投资余额(元)：%@",[formatter stringFromNumber:[NSNumber numberWithDouble:balance]]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳";
        [hud hide:YES afterDelay:1.5f];
    }];
    
    if (biggestBonus)
    {
        bonusNumLabel.text = [biggestBonus objectForKey:@"money"];
        bonusLimitLabel.text = [NSString stringWithFormat:@"起投金额%@元",[biggestBonus objectForKey:@"thresholdValue"]];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[biggestBonus objectForKey:@"expireTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        
        bonusDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
    }
    
    if (biggestCoupons)
    {
        couponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"raiseRate"]].intValue];
        couponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue/10000];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[biggestCoupons objectForKey:@"expireTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        
        couponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
    }
    
    if (biggestStandingCoupons)
    {
        standingCouponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"raiseRate"]].intValue];
        standingCouponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue/10000];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[biggestStandingCoupons objectForKey:@"expireTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        
        standingCouponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
    }
}

- (void)setupCoupons
{
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    NSString *URL1 = [BASEURL stringByAppendingString:@"api/account/couponInfo4M"];
    [manager1 GET:URL1 parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        bonus = [[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"coupons"]];
        for (int i = 0; i < bonus.count; i++)
        {
            id data = [bonus objectAtIndex:i];
            if (biggestBonus == nil)
            {
                biggestBonus = data;
            }
            else
            {
                if ([NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"money"]].intValue < [NSString stringWithFormat:@"%@",[data objectForKey:@"money"]].intValue)
                {
                    biggestBonus = data;
                }
            }
        }
        if (biggestBonus)
        {
            bonusView.hidden = NO;
            if (bonus.count > 1)
            {
                bonusMoreButton.hidden = NO;
            }
            bonusNumLabel.text = [biggestBonus objectForKey:@"money"];
            bonusLimitLabel.text = [NSString stringWithFormat:@"起投金额%@元",[biggestBonus objectForKey:@"thresholdValue"]];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
            NSDate *startDate = [dateFormat dateFromString:[biggestBonus objectForKey:@"expireTime"]];
            NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
            
            long year = [components year];
            long month = [components month];
            long day = [components day];
            
            bonusDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"登录信息已过期，请重新登录";
            SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
            setpass.string = @"验证密码";
            [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
        [hud hide:YES afterDelay:1.5f];
    }];
    
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
    NSString *URL2 = [BASEURL stringByAppendingString:@"api/voucher/myVouchers/true"];
    [manager2 GET:URL2 parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        coupons = [[NSMutableArray alloc]init];
        standingCoupons = [[NSMutableArray alloc]init];
        for (int i = 0; i < responseObject.count; i++)
        {
            id data = [responseObject objectAtIndex:i];
            if ([[data objectForKey:@"type"] isEqualToString:@"定期加息券"])
            {
                [coupons addObject:data];
                if (biggestCoupons == nil)
                {
                    biggestCoupons = data;
                }
                else
                {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date1 = [dateFormatter dateFromString:[biggestCoupons objectForKey:@"expireTime"]];
                    NSDate *date2 = [dateFormatter dateFromString:[data objectForKey:@"expireTime"]];
                    if ([date1 timeIntervalSinceDate:date2] < 0.0)
                    {
                        biggestCoupons = data;
                    }
                }
            }
            else
            {
                [standingCoupons addObject:data];
                if (biggestStandingCoupons == nil)
                {
                    biggestStandingCoupons = data;
                }
                else
                {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date1 = [dateFormatter dateFromString:[biggestStandingCoupons objectForKey:@"expireTime"]];
                    NSDate *date2 = [dateFormatter dateFromString:[data objectForKey:@"expireTime"]];
                    if ([date1 timeIntervalSinceDate:date2] < 0.0)
                    {
                        biggestStandingCoupons = data;
                    }
                }
            }
        }
        if (biggestCoupons)
        {
            couponsView.hidden = NO;
            if (coupons.count > 1)
            {
                couponsMoreButton.hidden = NO;
            }
            couponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"raiseRate"]].intValue];
            couponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue/10000];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
            NSDate *startDate = [dateFormat dateFromString:[biggestCoupons objectForKey:@"expireTime"]];
            NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
            
            long year = [components year];
            long month = [components month];
            long day = [components day];
            
            couponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
            
        }
        if (biggestStandingCoupons)
        {
            standingCouponsView.hidden = NO;
            if (standingCoupons.count > 1)
            {
                standingCouponsMoreButton.hidden = NO;
            }
            standingCouponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"raiseRate"]].intValue];
            standingCouponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue/10000];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
            NSDate *startDate = [dateFormat dateFromString:[biggestStandingCoupons objectForKey:@"expireTime"]];
            NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
            
            long year = [components year];
            long month = [components month];
            long day = [components day];
            
            standingCouponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"登录信息已过期，请重新登录";
            SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
            setpass.string = @"验证密码";
            [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
        [hud hide:YES afterDelay:1.5f];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toAgreemet:(id)sender
{
    WebDetailViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
    [vc setURL:[NSString stringWithFormat:@"%@/Mobile/Home/InvestAgreement4M?productCode=%@", BASEURL, idOrCode]];
    vc.title = @"专投网购买协议";
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)confirm:(id)sender
{
    BOOL flag = false;
    if (!flag && ![style isEqualToString:HUOQI])
    {
        for (int i=0; i<bonus.count; i++)
        {
            id data = [bonus objectAtIndex:i];
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"thresholdValue"]].intValue <= amountTextField.text.intValue)
            {
                flag = true;
                break;
            }
        }
    }
    if (!flag && ![style isEqualToString:HUOQI])
    {
        for (int i=0; i<coupons.count; i++)
        {
            id data = [coupons objectAtIndex:i];
            if (([NSString stringWithFormat:@"%@",[data objectForKey:@"threshold"]].intValue <= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue))
            {
                flag = true;
                break;
            }
        }
    }
    if (!flag && ![style isEqualToString:HUOQI])
    {
        for (int i=0; i<standingCoupons.count; i++)
        {
            id data = [standingCoupons objectAtIndex:i];
            if (([NSString stringWithFormat:@"%@",[data objectForKey:@"threshold"]].intValue <= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue))
            {
                flag = true;
                break;
            }
        }
    }
    if ((int)round(amountTextField.text.doubleValue * 100) > (int)round(balance * 100))
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"可用余额不足";
        [hud hide:YES afterDelay:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [amountTextField becomeFirstResponder];
        });
    }
    else if ((![style isEqualToString:HUOQI]) && (amountTextField.text.intValue < ((NSString*)[productInfo objectForKey:@"minPurchaseAmount"]).intValue))
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = [NSString stringWithFormat:@"最低投资额度为%@元",[productInfo objectForKey:@"minPurchaseAmount"]];
        [hud hide:YES afterDelay:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [amountTextField becomeFirstResponder];
        });
    }
    else if ((![style isEqualToString:HUOQI]) && (amountTextField.text.intValue % 100 != 0))
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"投资额度必须为100的整数倍";
        [hud hide:YES afterDelay:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [amountTextField becomeFirstResponder];
        });
    }
    else if ((![style isEqualToString:HUOQI]) && flag)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还有可使用的红包或优惠券，是否前往下一页面？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *gotoNext= [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            ProductBuyConfirmViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyConfirmViewController"];
            [vc setStyle:style];
            vc.title = self.title;
            vc.isFromNewer = self.isFromNewer;
            vc.investAmount = amountTextField.text;
            vc.coupons = coupon;
            vc.vouchers = vouchers;
            NSLog(@"%@",coupons);
            vc.idOrCode = idOrCode;
            vc.productInfo = productInfo;
            [[self navigationController]pushViewController:vc animated:YES];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:gotoNext];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        if ([style isEqualToString:HUOQI])
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if (amountTextField.text.doubleValue < 0.01)
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = [NSString stringWithFormat:@"最低投资额度为0.01元"];
                [hud hide:YES afterDelay:1.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [amountTextField becomeFirstResponder];
                });
            }
            else if (![userDefault boolForKey:ISTRADEPSWDSET])
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未设置交易密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *gotoSet = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    SetTradePswdViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetTradePswdViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:gotoSet];
                [alertController addAction:cancel];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                if ((int)(amountTextField.text.doubleValue*100) <= [userDefault integerForKey:TPTHRESHOLD])
                {
                    [self buy:@""];
                }
                else
                {
                    if ([userDefault boolForKey:ISTPNUMERIC])
                    {
                        TradePswdView *view = [[TradePswdView alloc]initWithFrame:self.navigationController.view.frame];
                        view.block = ^(NSString *tradePswd) {
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                            NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/transferIntoZtb4M?amount=%@&tradePassword=%@",amountTextField.text,tradePswd]];
                            [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                NSLog(@"%@",responseObject);
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
                                    hud.labelText = @"转入成功";
                                    [hud hide:YES afterDelay:1.5f];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [[self navigationController]popViewControllerAnimated:YES];
                                    });
                                }
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", error);
                                hud.mode = MBProgressHUDModeText;
                                hud.labelText = @"当前网络状况不佳，请重试";
                                [hud hide:YES afterDelay:1.5f];
                            }];
                        };
                        [view showView];
                    }
                    else
                    {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入交易密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                            textField.secureTextEntry = YES;
                            textField.returnKeyType = UIReturnKeyDone;
                            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
                        }];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            UITextField *tradePswdTextField = alertController.textFields.firstObject;
                            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
                            [self buy:tradePswdTextField.text];
                        }];
                        [alertController addAction:cancelAction];
                        [alertController addAction:confirmAction];
                        confirmAction.enabled = NO;
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }
            }
        }
        else
        {
            ProductBuyConfirmViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyConfirmViewController"];
            [vc setStyle:style];
            vc.title = self.title;
            vc.isFromNewer = self.isFromNewer;
            vc.investAmount = amountTextField.text;
            vc.coupons = coupon;
            vc.vouchers = vouchers;
            NSLog(@"%@",coupons);
            vc.idOrCode = idOrCode;
            vc.productInfo = productInfo;
            [[self navigationController]pushViewController:vc animated:YES];
        }
    }
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *tradePswdTextField = alertController.textFields.firstObject;
        UIAlertAction *confirmAction = alertController.actions.lastObject;
        confirmAction.enabled = tradePswdTextField.text.length >= 6;
    }
}

- (void)buy:(NSString*)tradePswd
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/transferIntoZtb4M?amount=%@&tradePassword=%@",amountTextField.text,tradePswd]];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
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
            hud.labelText = @"转入成功";
            [hud hide:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[self navigationController]popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setStyle:(NSString*)str
{
    style = str;
}

- (void)toCharge:(id)sender
{
    ChargeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ChargeViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)checkboxEnsure:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"checkIconActive.png"] forState:UIControlStateNormal];
        if (amountTextField.text.length > 0)
        {
            [confirmButton setUserInteractionEnabled:YES];
            [confirmButton setAlpha:1.0f];
        }
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"checkIcon.png"] forState:UIControlStateNormal];
        [confirmButton setUserInteractionEnabled:NO];
        [confirmButton setAlpha:0.6f];
    }
    
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [amountTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [amountTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if (amountTextField.text.length > 0)
    {
        [confirmButton setUserInteractionEnabled:YES];
        [confirmButton setAlpha:1.0f];
    }
    else
    {
        [confirmButton setUserInteractionEnabled:NO];
        [confirmButton setAlpha:0.6f];
    }
}

@end
