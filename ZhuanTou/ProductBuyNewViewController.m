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

@synthesize amountTextField, confirmButton, checkboxButton, agreementButton, chargeButton, balanceLabel, restLabel, tView, allInButton, checkboxBigButton;
@synthesize style, idOrCode, productInfo, bidableAmount;
@synthesize buttonBottomLayOut;
@synthesize coupon, vouchers, biggestBonus, biggestCoupons, biggestStandingCoupons;
@synthesize couponsFlagChosen, voucher1FlagChosen, voucher2FlagChosen;

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
    [checkboxBigButton addTarget:self action:@selector(checkboxEnsure:) forControlEvents:UIControlEventTouchUpInside];
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
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    NSLog(@"%@",bidableAmount);
    restLabel.text = [NSString stringWithFormat:@"可购份额(元)：%@万",[formatter stringFromNumber:[NSNumber numberWithDouble:bidableAmount.doubleValue/10000]]];
    
    SCNumberKeyBoard *keyboard = [SCNumberKeyBoard showWithTextField:amountTextField enter:nil close:nil];
    [keyboard.enterButton setBackgroundColor:ZTBLUE];
    [keyboard.enterButton setTitle:@"确定" forState:UIControlStateNormal];
    [keyboard.enterButton addTarget:self action:@selector(AIChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    coupon = @"";
    vouchers = @"";
    couponsFlag = voucher1Flag = voucher2Flag = false;
    if (![style isEqualToString:HUOQI])
    {
        [self setupCoupons];
    }
    
    [amountTextField becomeFirstResponder];
    [amountTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    [allInButton addTarget:self action:@selector(allIn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self buttonEnableListener:nil];
}

- (void)dealloc
{
    [amountTextField removeObserver:self forKeyPath:@"text"];
}

- (void)allIn:(id)sender
{
    amountTextField.text = [NSString stringWithFormat:@"%.2f", balance];
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
            if (([NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"faceValue"]].intValue < [NSString stringWithFormat:@"%@",[data objectForKey:@"faceValue"]].intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"thresholdValue"]].intValue <= amountTextField.text.intValue))
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

- (void)chooseBonus:(UIButton *)sender
{
    if (!couponsFlag)
    {
        if (amountTextField.text.intValue >= [NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"thresholdValue"]].intValue)
        {
            couponsFlag = YES;
            couponsFlagChosen = YES;
            coupon = [NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"couponCode"]];
            [tView reloadData];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"使用红包金额不少于%@元",[biggestBonus objectForKey:@"thresholdValue"]];
            [hud hide:YES afterDelay:1.5];
        }
    }
    else
    {
        couponsFlag = NO;
        couponsFlagChosen = NO;
        coupon = @"";
        [tView reloadData];
    }
}

- (void)toChooseBonusView:(UIButton*)sender
{
    ChooseBonusViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ChooseBonusViewController"];
    vc.amount = amountTextField.text.intValue;
    if (sender.tag == 0)
    {
        vc.style = BONUS;
        vc.datas = [[NSMutableArray alloc]initWithArray:bonus];
        vc.choosen = biggestBonus;
        vc.chooseFlag = couponsFlag;
    }
    else if (sender.tag == 1)
    {
        vc.style = COUPONS;
        vc.datas = [[NSMutableArray alloc]initWithArray:coupons];
        vc.choosen = biggestCoupons;
        vc.chooseFlag = voucher1Flag;
    }
    else
    {
        vc.style = STANDINGCOUPONS;
        vc.datas = [[NSMutableArray alloc]initWithArray:standingCoupons];
        vc.choosen = biggestStandingCoupons;
        vc.chooseFlag = voucher2Flag;
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

- (void)chooseCoupons:(UIButton*)sender
{
    if (!voucher1Flag)
    {
        if (amountTextField.text.length == 0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入投资金额";
            [hud hide:YES afterDelay:1.5];
        }
        else if (amountTextField.text.intValue > [NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"单张加息券投资上限%d万，请修改金额拆分投资",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue/10000];
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
            voucher1Flag = YES;
            voucher1FlagChosen = YES;
            if (vouchers.length > 0)
            {
                vouchers = [vouchers stringByAppendingString:[NSString stringWithFormat:@",%@",[biggestCoupons objectForKey:@"voucherCode"]]];
            }
            else
            {
                vouchers = [biggestCoupons objectForKey:@"voucherCode"];
            }
            [tView reloadData];
        }
    }
    else
    {
        voucher1Flag = NO;
        voucher1FlagChosen = NO;
        vouchers = [vouchers stringByReplacingOccurrencesOfString:[biggestCoupons objectForKey:@"voucherCode"] withString:@""];
        if (vouchers.length > 0)
        {
            if ([[vouchers substringFromIndex:(vouchers.length-1)] isEqualToString:@","])
            {
                vouchers = [vouchers substringToIndex:(vouchers.length-1)];
            }
        }
        [tView reloadData];
    }
    NSLog(@"voucher:%@",vouchers);
}

- (void)chooseStandingCoupons:(UIButton*)sender
{
    if (!voucher2Flag)
    {
        if (amountTextField.text.length == 0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入投资金额";
            [hud hide:YES afterDelay:1.5];
        }
        else if (amountTextField.text.intValue > [NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"principalLimit"]].intValue)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"单张加息券投资上限%d万，请修改金额拆分投资",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"principalLimit"]].intValue/10000];
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
            voucher2Flag = YES;
            voucher2FlagChosen = YES;
            if (vouchers.length > 0)
            {
                vouchers = [vouchers stringByAppendingString:[NSString stringWithFormat:@",%@",[biggestStandingCoupons objectForKey:@"voucherCode"]]];
            }
            else
            {
                vouchers = [biggestStandingCoupons objectForKey:@"voucherCode"];
            }
            [tView reloadData];
        }
    }
    else
    {
        voucher2Flag = NO;
        voucher2FlagChosen = NO;
        vouchers = [vouchers stringByReplacingOccurrencesOfString:[biggestStandingCoupons objectForKey:@"voucherCode"] withString:@""];
        if (vouchers.length > 0)
        {
            if ([[vouchers substringFromIndex:(vouchers.length-1)] isEqualToString:@","])
            {
                vouchers = [vouchers substringToIndex:(vouchers.length-1)];
            }
        }
        [tView reloadData];
    }
    NSLog(@"voucher:%@",vouchers);
}

- (void)viewWillAppear:(BOOL)animated
{
    couponsFlag = couponsFlagChosen;
    voucher1Flag = voucher1FlagChosen;
    voucher2Flag = voucher2FlagChosen;
    if ([style isEqualToString:HUOQI])
    {
        balanceLabel.text = @"可用余额(元)：";
        allInButton.hidden = NO;
    }
    else
    {
        balanceLabel.text = @"可投资余额(元)：";
        allInButton.hidden = YES;
    }
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

    [tView reloadData];
}

- (void)setupCoupons
{
    bonusLoadFinished = NO;
    couponLoadFinished = NO;
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
                if ([NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"faceValue"]].intValue < [NSString stringWithFormat:@"%@",[data objectForKey:@"faceValue"]].intValue)
                {
                    biggestBonus = data;
                }
            }
        }
        bonusLoadFinished = YES;
        if (bonusLoadFinished && couponLoadFinished){
            [tView reloadData];
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
            if (![NSString stringWithFormat:@"%@", [data objectForKey:@"expired"]].boolValue)
            {
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
        }
        couponLoadFinished = YES;
        if (bonusLoadFinished && couponLoadFinished){
            [tView reloadData];
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
    [vc setURL:[NSString stringWithFormat:@"%@Wap/WebView/InvestAgreement4M?productCode=%@", BASEURL, idOrCode]];
    vc.title = @"专投网产品服务协议";
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)confirm:(id)sender
{
    BOOL flag = false;
    BOOL coupflag = false;
    BOOL vouc1flag = false;
    BOOL vouc2flag = false;
    
    if (!flag && ![style isEqualToString:HUOQI] && couponsFlag)
    {
        for (int i=0; i<bonus.count; i++)
        {
            id data = [bonus objectAtIndex:i];
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"thresholdValue"]].intValue <= amountTextField.text.intValue)
            {
                coupflag = true;
                break;
            }
        }
    }
    if (!flag && ![style isEqualToString:HUOQI] && voucher1Flag)
    {
        for (int i=0; i<coupons.count; i++)
        {
            id data = [coupons objectAtIndex:i];
            if (([NSString stringWithFormat:@"%@",[data objectForKey:@"threshold"]].intValue <= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue))
            {
                vouc1flag = true;
                break;
            }
        }
    }
    if (!flag && ![style isEqualToString:HUOQI] && voucher2Flag)
    {
        for (int i=0; i<standingCoupons.count; i++)
        {
            id data = [standingCoupons objectAtIndex:i];
            if (([NSString stringWithFormat:@"%@",[data objectForKey:@"threshold"]].intValue <= amountTextField.text.intValue) && ([NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue >= amountTextField.text.intValue))
            {
                vouc2flag = true;
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
        hud.labelText = [NSString stringWithFormat:@"最低投资限额%@元",[productInfo objectForKey:@"minPurchaseAmount"]];
        [hud hide:YES afterDelay:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [amountTextField becomeFirstResponder];
        });
    }
    else if ((![style isEqualToString:HUOQI]) && (amountTextField.text.intValue % 100 != 0) && (!couponsFlag))
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"投资额度必须为100的整数倍";
        [hud hide:YES afterDelay:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [amountTextField becomeFirstResponder];
        });
    }
    else if ((![style isEqualToString:HUOQI]) && ((amountTextField.text.intValue + [NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"faceValue"]].intValue) % 100 != 0) && (couponsFlag))
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"投资额度必须为100的整数倍";
        [hud hide:YES afterDelay:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [amountTextField becomeFirstResponder];
        });
    }
    else if ((![style isEqualToString:HUOQI]) && !((coupflag || !biggestBonus) && (vouc1flag || !biggestCoupons) && (vouc2flag || !biggestStandingCoupons)))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您有未使用的优惠券，是否需要使用？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *gotoNext= [UIAlertAction actionWithTitle:@"直接购买产品" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
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
            if (couponsFlag)
            {
                vc.bonus = biggestBonus;
            }
            if (voucher1Flag)
            {
                vc.voucher1 = biggestCoupons;
            }
            if (voucher2Flag)
            {
                vc.voucher2 = biggestStandingCoupons;
            }
            [[self navigationController]pushViewController:vc animated:YES];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"使用优惠券" style:UIAlertActionStyleCancel handler:nil];
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
                        [self.navigationController.view addSubview:view];
                        [view showView];
                    }
                    else
                    {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入交易密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
            NSLog(@"%@",vouchers);
            vc.idOrCode = idOrCode;
            vc.productInfo = productInfo;
            if (couponsFlag)
            {
                vc.bonus = biggestBonus;
            }
            if (voucher1Flag)
            {
                vc.voucher1 = biggestCoupons;
            }
            if (voucher2Flag)
            {
                vc.voucher2 = biggestStandingCoupons;
            }
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
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/transferIntoZtb?amount=%@",amountTextField.text]];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 0)
        {
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.5f];
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorCode"]] isEqualToString:@"100003"])
            {
                hud.labelText = @"登录信息已过期，请重新登录";
                SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
                setpass.string = @"验证密码";
                [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
            }
            else if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorCode"]] isEqualToString:@"TradelPasswordIncorrect"])
            {
                [hud hide:YES];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"交易密码错误，请重试" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self confirm:nil];
                }];
                UIAlertAction *forgottenAction = [UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    ForgottenViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ForgottenViewController"];
                    [vc setStyle:RESETTRADEPSWD];
                    [[self navigationController]pushViewController:vc animated:YES];
                }];
                [alertController addAction:retryAction];
                [alertController addAction:forgottenAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                hud.labelText = [responseObject objectForKey:@"errorMessage"];
            }
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
    checkboxButton.selected = !checkboxButton.selected;
    if (checkboxButton.selected)
    {
        [checkboxButton setImage:[UIImage imageNamed:@"checkIconActive.png"] forState:UIControlStateNormal];
        if (amountTextField.text.length > 0)
        {
            [confirmButton setUserInteractionEnabled:YES];
            [confirmButton setAlpha:1.0f];
        }
    }
    else
    {
        [checkboxButton setImage:[UIImage imageNamed:@"checkIcon.png"] forState:UIControlStateNormal];
        [confirmButton setUserInteractionEnabled:NO];
        [confirmButton setAlpha:0.6f];
    }
    
}

- (IBAction)textFieldBeginEditing:(id)sender
{
    if (couponsFlag)
    {
        [self chooseBonus:nil];
    }
    if (voucher1Flag)
    {
        [self chooseCoupons:nil];
    }
    if (voucher2Flag)
    {
        [self chooseStandingCoupons:nil];
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

#pragma TableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (biggestBonus && biggestCoupons && biggestStandingCoupons)
    {
        return 5;
    }
    else if ((biggestBonus && biggestCoupons && !biggestStandingCoupons) || (biggestBonus && !biggestCoupons && biggestStandingCoupons))
    {
        return 4;
    }
    else if (!biggestBonus && biggestCoupons && biggestStandingCoupons)
    {
        return 3;
    }
    else if ((biggestBonus && !biggestCoupons && !biggestStandingCoupons) || (!biggestBonus && biggestCoupons && !biggestStandingCoupons) || (!biggestBonus && !biggestCoupons && biggestStandingCoupons))
    {
        return 2;
    }
    else
    {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2)
    {
        if (!biggestBonus && indexPath.row == 2){
            return 83;
        }
        else{
            return 15;
        }
    }
    else
    {
        return 83;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"ProductLabelTableViewCell";
    static NSString *identifier2 = @"ProductCouponsTableViewCell";
    static NSString *identifier3 = @"ProductVoucherTableViewCell";
    if (indexPath.row == 0)
    {
        ProductLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell)
        {
            cell = [[ProductLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        if (biggestBonus)
        {
            cell.label.text = @"选择红包";
        }
        else
        {
            cell.label.text = @"选择加息券";
        }
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        if (biggestBonus)
        {
            ProductCouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (!cell)
            {
                cell = [[ProductCouponsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            }
            if (bonus.count > 1)
            {
                cell.bonusMoreButton.hidden = NO;
            }
            else
            {
                cell.bonusMoreButton.hidden = YES;
            }
            cell.bonusMoreButton.tag = 0;
            [cell.bonusMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.bonusButton addTarget:self action:@selector(chooseBonus:) forControlEvents:UIControlEventTouchUpInside];
            cell.bonusNumLabel.text = [NSString stringWithFormat:@"%@",[biggestBonus objectForKey:@"faceValue"]];
            cell.bonusLimitLabel.text = [NSString stringWithFormat:@"起投金额%@元",[biggestBonus objectForKey:@"thresholdValue"]];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
            NSDate *startDate = [dateFormat dateFromString:[biggestBonus objectForKey:@"expireTime"]];
            NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
            
            long year = [components year];
            long month = [components month];
            long day = [components day];
            
            cell.bonusDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
            
            if (couponsFlag)
            {
                cell.bonusBgView.backgroundColor = ZTLIGHTRED;
                cell.bonusDDLLabel.textColor = ZTLIGHTRED;
                cell.bonusLimitLabel.textColor = ZTLIGHTRED;
            }
            else
            {
                cell.bonusBgView.backgroundColor = ZTGRAY;
                cell.bonusDDLLabel.textColor = ZTGRAY;
                cell.bonusLimitLabel.textColor = ZTGRAY;
            }
            
            return cell;
        }
        else if (biggestCoupons)
        {
            ProductVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if (!cell)
            {
                cell = [[ProductVoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
            }
            if (coupons.count > 1)
            {
                cell.couponsMoreButton.hidden = NO;
            }
            else
            {
                cell.couponsMoreButton.hidden = YES;
            }
            cell.couponsMoreButton.tag = 1;
            [cell.couponsMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.couponsButton addTarget:self action:@selector(chooseCoupons:) forControlEvents:UIControlEventTouchUpInside];
            cell.couponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"raiseRate"]].intValue];
            cell.couponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue/10000];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
            NSDate *startDate = [dateFormat dateFromString:[biggestCoupons objectForKey:@"expireTime"]];
            NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
            
            long year = [components year];
            long month = [components month];
            long day = [components day];
            
            cell.couponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
            cell.couponsTitleLabel.text = @"定期加息券";
            if (voucher1Flag)
            {
                cell.couponsBgView.backgroundColor = ZTBLUE;
                cell.couponsDDLLabel.textColor = ZTBLUE;
                cell.couponsLimitLabel.textColor = ZTBLUE;
            }
            else
            {
                cell.couponsBgView.backgroundColor = ZTGRAY;
                cell.couponsDDLLabel.textColor = ZTGRAY;
                cell.couponsLimitLabel.textColor = ZTGRAY;
            }
            
            return cell;
        }
        else
        {
            ProductVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if (!cell)
            {
                cell = [[ProductVoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
            }
            if (standingCoupons.count > 1)
            {
                cell.couponsMoreButton.hidden = NO;
            }
            else
            {
                cell.couponsMoreButton.hidden = YES;
            }
            cell.couponsMoreButton.tag = 2;
            [cell.couponsMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.couponsButton addTarget:self action:@selector(chooseStandingCoupons:) forControlEvents:UIControlEventTouchUpInside];
            cell.couponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"raiseRate"]].intValue];
            cell.couponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"principalLimit"]].intValue/10000];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
            NSDate *startDate = [dateFormat dateFromString:[biggestStandingCoupons objectForKey:@"expireTime"]];
            NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
            
            long year = [components year];
            long month = [components month];
            long day = [components day];
            
            cell.couponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
            cell.couponsTitleLabel.text = @"募集期加息券";
            if (voucher2Flag)
            {
                cell.couponsBgView.backgroundColor = ZTBLUE;
                cell.couponsDDLLabel.textColor = ZTBLUE;
                cell.couponsLimitLabel.textColor = ZTBLUE;
            }
            else
            {
                cell.couponsBgView.backgroundColor = ZTGRAY;
                cell.couponsDDLLabel.textColor = ZTGRAY;
                cell.couponsLimitLabel.textColor = ZTGRAY;
            }
            
            return cell;
        }
    }
    else if (indexPath.row == 2)
    {
        if (biggestBonus) {
            ProductLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (!cell)
            {
                cell = [[ProductLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            }
            cell.label.text = @"选择加息券";
            return cell;
        }
        else {
            ProductVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if (!cell)
            {
                cell = [[ProductVoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
            }
            if (coupons.count > 1)
            {
                cell.couponsMoreButton.hidden = NO;
            }
            else
            {
                cell.couponsMoreButton.hidden = YES;
            }
            cell.couponsMoreButton.tag = 2;
            [cell.couponsMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.couponsButton addTarget:self action:@selector(chooseStandingCoupons:) forControlEvents:UIControlEventTouchUpInside];
            cell.couponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"raiseRate"]].intValue];
            cell.couponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"principalLimit"]].intValue/10000];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
            NSDate *startDate = [dateFormat dateFromString:[biggestStandingCoupons objectForKey:@"expireTime"]];
            NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
            
            long year = [components year];
            long month = [components month];
            long day = [components day];
            
            cell.couponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
            cell.couponsTitleLabel.text = @"募集期加息券";
            if (voucher2Flag)
            {
                cell.couponsBgView.backgroundColor = ZTBLUE;
                cell.couponsDDLLabel.textColor = ZTBLUE;
                cell.couponsLimitLabel.textColor = ZTBLUE;
            }
            else
            {
                cell.couponsBgView.backgroundColor = ZTGRAY;
                cell.couponsDDLLabel.textColor = ZTGRAY;
                cell.couponsLimitLabel.textColor = ZTGRAY;
            }
            return cell;
        }
    }
    else if (indexPath.row == 3)
    {
        if (biggestCoupons)
        {
            ProductVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if (!cell)
            {
                cell = [[ProductVoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
            }
            if (coupons.count > 1)
            {
                cell.couponsMoreButton.hidden = NO;
            }
            else
            {
                cell.couponsMoreButton.hidden = YES;
            }
            cell.couponsMoreButton.tag = 1;
            [cell.couponsMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.couponsButton addTarget:self action:@selector(chooseCoupons:) forControlEvents:UIControlEventTouchUpInside];
            cell.couponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"raiseRate"]].intValue];
            cell.couponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestCoupons objectForKey:@"principalLimit"]].intValue/10000];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
            NSDate *startDate = [dateFormat dateFromString:[biggestCoupons objectForKey:@"expireTime"]];
            NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
            
            long year = [components year];
            long month = [components month];
            long day = [components day];
            
            cell.couponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
            cell.couponsTitleLabel.text = @"定期加息券";
            if (voucher1Flag)
            {
                cell.couponsBgView.backgroundColor = ZTBLUE;
                cell.couponsDDLLabel.textColor = ZTBLUE;
                cell.couponsLimitLabel.textColor = ZTBLUE;
            }
            else
            {
                cell.couponsBgView.backgroundColor = ZTGRAY;
                cell.couponsDDLLabel.textColor = ZTGRAY;
                cell.couponsLimitLabel.textColor = ZTGRAY;
            }
            
            return cell;
        }
        else
        {
            ProductVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if (!cell)
            {
                cell = [[ProductVoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
            }
            if (standingCoupons.count > 1)
            {
                cell.couponsMoreButton.hidden = NO;
            }
            else
            {
                cell.couponsMoreButton.hidden = YES;
            }
            cell.couponsMoreButton.tag = 2;
            [cell.couponsMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.couponsButton addTarget:self action:@selector(chooseStandingCoupons:) forControlEvents:UIControlEventTouchUpInside];
            cell.couponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"raiseRate"]].intValue];
            cell.couponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"principalLimit"]].intValue/10000];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
            NSDate *startDate = [dateFormat dateFromString:[biggestStandingCoupons objectForKey:@"expireTime"]];
            NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
            
            long year = [components year];
            long month = [components month];
            long day = [components day];
            
            cell.couponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
            cell.couponsTitleLabel.text = @"募集期加息券";
            if (voucher2Flag)
            {
                cell.couponsBgView.backgroundColor = ZTBLUE;
                cell.couponsDDLLabel.textColor = ZTBLUE;
                cell.couponsLimitLabel.textColor = ZTBLUE;
            }
            else
            {
                cell.couponsBgView.backgroundColor = ZTGRAY;
                cell.couponsDDLLabel.textColor = ZTGRAY;
                cell.couponsLimitLabel.textColor = ZTGRAY;
            }
            
            return cell;
        }
    }
    else
    {
        ProductVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!cell)
        {
            cell = [[ProductVoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
        }
        if (standingCoupons.count > 1)
        {
            cell.couponsMoreButton.hidden = NO;
        }
        else
        {
            cell.couponsMoreButton.hidden = YES;
        }
        cell.couponsMoreButton.tag = 2;
        [cell.couponsMoreButton addTarget:self action:@selector(toChooseBonusView:) forControlEvents:UIControlEventTouchUpInside];
        [cell.couponsButton addTarget:self action:@selector(chooseStandingCoupons:) forControlEvents:UIControlEventTouchUpInside];
        cell.couponsNumLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"raiseRate"]].intValue];
        cell.couponsLimitLabel.text = [NSString stringWithFormat:@"投资上限%d万元",[NSString stringWithFormat:@"%@",[biggestStandingCoupons objectForKey:@"principalLimit"]].intValue/10000];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[biggestStandingCoupons objectForKey:@"expireTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        
        cell.couponsDDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
        cell.couponsTitleLabel.text = @"募集期加息券";
        if (voucher2Flag)
        {
            cell.couponsBgView.backgroundColor = ZTBLUE;
            cell.couponsDDLLabel.textColor = ZTBLUE;
            cell.couponsLimitLabel.textColor = ZTBLUE;
        }
        else
        {
            cell.couponsBgView.backgroundColor = ZTGRAY;
            cell.couponsDDLLabel.textColor = ZTGRAY;
            cell.couponsLimitLabel.textColor = ZTGRAY;
        }
        
        return cell;
    }
}

@end
