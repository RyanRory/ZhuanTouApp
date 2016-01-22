//
//  ProductBuyConfirmViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/16.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductBuyConfirmViewController.h"

@interface ProductBuyConfirmViewController ()

@end

@implementation ProductBuyConfirmViewController

@synthesize confirmButton;
@synthesize bgView, titleLabel, incomeRateLabel, amoutLabel, realPayLabel, productTimeLabel, staIncome, youUsedLabel, voucher1Label, voucher1NumLabel, voucher2Label, voucher2NumLabel, voucher1View, voucher2View, contentView;
@synthesize investAmount, coupons, vouchers, idOrCode, productInfo, bonus, voucher1, voucher2;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    confirmButton.layer.cornerRadius = 3;
    
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    voucher1View.hidden = YES;
    voucher2View.hidden = YES;
    
    if ([style isEqualToString:WENJIAN])
    {
        [self setupWenjian];
    }
    else
    {
        [self setupZonghe];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (voucher1View.hidden && voucher2View.hidden)
    {
        contentView.layer.cornerRadius = 3;
    }
    else if (voucher2View.hidden)
    {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = contentView.frame;
        maskLayer.path = maskPath.CGPath;
        contentView.layer.mask = maskLayer;
        contentView.layer.masksToBounds = YES;
        
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:voucher1View.frame byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = voucher1View.frame;
        maskLayer1.path = maskPath1.CGPath;
        voucher1View.layer.mask = maskLayer1;
        voucher1View.layer.masksToBounds = YES;
    }
    else
    {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = contentView.frame;
        maskLayer.path = maskPath.CGPath;
        contentView.layer.mask = maskLayer;
        contentView.layer.masksToBounds = YES;
        
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:voucher1View.frame byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = voucher2View.frame;
        maskLayer1.path = maskPath1.CGPath;
        voucher2View.layer.mask = maskLayer1;
        voucher2View.layer.masksToBounds = YES;
    }
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setStyle:(NSString*)str
{
    style = str;
}

-(void)setupWenjian
{
    confirmButton.backgroundColor = ZTLIGHTRED;
    bgView.backgroundColor = ZTLIGHTRED;
    incomeRateLabel.textColor = ZTLIGHTRED;
    amoutLabel.textColor = ZTLIGHTRED;
    realPayLabel.textColor = ZTLIGHTRED;
    productTimeLabel.textColor = ZTLIGHTRED;
    staIncome.textColor = ZTLIGHTRED;
    youUsedLabel.textColor = ZTLIGHTRED;
    voucher1Label.textColor = ZTLIGHTRED;
    voucher1NumLabel.textColor = ZTLIGHTRED;
    voucher2Label.textColor = ZTLIGHTRED;
    voucher2NumLabel.textColor = ZTLIGHTRED;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0"];
    incomeRateLabel.text = [NSString stringWithFormat:@"预期年化收益率：%@%%",[productInfo objectForKey:@"interestRate"]];
    amoutLabel.text = [NSString stringWithFormat:@"购  买  金  额 (元)：%@",[NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithInt:investAmount.intValue]]]];
    if (bonus)
    {
        realPayLabel.text = [NSString stringWithFormat:@"实际支付金额(元)：%@",[NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithInt:(investAmount.intValue - [NSString stringWithFormat:@"%@",[bonus objectForKey:@"money"]].intValue)]]]];
    }
    else
        
    {
        realPayLabel.text = [NSString stringWithFormat:@"实际支付金额(元)：%@",[NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithInt:investAmount.intValue]]]];
    }
    productTimeLabel.text = [NSString stringWithFormat:@"到   期   时   间 ：%@",[productInfo objectForKey:@"endDate"]];
    
    int jiaxiquan;
    if (voucher1)
    {
        jiaxiquan = jiaxiquan + [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue;
        voucher1View.hidden = NO;
        voucher1NumLabel.text = @"1张";
        voucher1Label.text = [NSString stringWithFormat:@"定期加息券  (+%d%%)", [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue];
    }
    
    if (voucher2)
    {
        jiaxiquan = jiaxiquan + [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue;
        if (voucher1View.hidden)
        {
            voucher1View.hidden = NO;
            voucher1NumLabel.text = @"1张";
            voucher1Label.text = [NSString stringWithFormat:@"募集期加息券  (+%d%%)", [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue];
        }
        else
        {
            voucher2View.hidden = NO;
            voucher2NumLabel.text = @"1张";
            voucher2Label.text = [NSString stringWithFormat:@"募集期加息券  (+%d%%)", [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue];
        }
    }
    
    staIncome.text = [NSString stringWithFormat:@"固定派息总计(元)：%@",[formatter stringFromNumber:[NSNumber numberWithDouble:round( (pow(1+[NSString stringWithFormat:@"%@",[productInfo objectForKey:@"interestRate"]].intValue+jiaxiquan, 1.0/12.0)-1)/365*12*[NSString stringWithFormat:@"%@",[productInfo objectForKey:@"noOfDays"]].intValue * 100 * investAmount.intValue)/100]]];
    
    
}

- (void)setupZonghe
{
    bgView.backgroundColor = ZTBLUE;
    confirmButton.backgroundColor = ZTBLUE;
    incomeRateLabel.textColor = ZTBLUE;
    amoutLabel.textColor = ZTBLUE;
    realPayLabel.textColor = ZTBLUE;
    productTimeLabel.textColor = ZTBLUE;
    staIncome.textColor = ZTBLUE;
    youUsedLabel.textColor = ZTBLUE;
    voucher1Label.textColor = ZTBLUE;
    voucher1NumLabel.textColor = ZTBLUE;
    voucher2Label.textColor = ZTBLUE;
    voucher2NumLabel.textColor = ZTBLUE;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0"];
    incomeRateLabel.text = [NSString stringWithFormat:@"预期年化收益率：%@%%",[productInfo objectForKey:@"expectedReturn"]];
    amoutLabel.text = [NSString stringWithFormat:@"购  买  金  额 (元)：%@",[NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithInt:investAmount.intValue]]]];
    if (bonus)
    {
        realPayLabel.text = [NSString stringWithFormat:@"实际支付金额(元)：%@",[NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithInt:(investAmount.intValue - [NSString stringWithFormat:@"%@",[bonus objectForKey:@"money"]].intValue)]]]];
    }
    else
        
    {
        realPayLabel.text = [NSString stringWithFormat:@"实际支付金额(元)：%@",[NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithInt:investAmount.intValue]]]];
    }
    productTimeLabel.text = [NSString stringWithFormat:@"到   期   时   间 ：%@",[productInfo objectForKey:@"endDate"]];
    
    int jiaxiquan;
    if (voucher1)
    {
        jiaxiquan = jiaxiquan + [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue;
        voucher1View.hidden = NO;
        voucher1NumLabel.text = @"1张";
        voucher1Label.text = [NSString stringWithFormat:@"定期加息券  (+%d%%)", [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue];
    }
    
    if (voucher2)
    {
        jiaxiquan = jiaxiquan + [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue;
        if (voucher1View.hidden)
        {
            voucher1View.hidden = NO;
            voucher1NumLabel.text = @"1张";
            voucher1Label.text = [NSString stringWithFormat:@"募集期加息券  (+%d%%)", [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue];
        }
        else
        {
            voucher2View.hidden = NO;
            voucher2NumLabel.text = @"1张";
            voucher2Label.text = [NSString stringWithFormat:@"募集期加息券  (+%d%%)", [NSString stringWithFormat:@"%@",[voucher1 objectForKey:@"raiseRate"]].intValue];
        }
    }
    
    staIncome.text = [NSString stringWithFormat:@"固定派息总计(元)：%@",[formatter stringFromNumber:[NSNumber numberWithDouble:round( (pow(1+[NSString stringWithFormat:@"%@",[productInfo objectForKey:@"interestRate"]].intValue+jiaxiquan, 1.0/12.0)-1)/365*12*[NSString stringWithFormat:@"%@",[productInfo objectForKey:@"noOfDays"]].intValue * 100 * investAmount.intValue)/100]]];
}

- (void)confirm:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault boolForKey:ISTRADEPSWDSET])
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
        if ([userDefault boolForKey:ISTPNUMERIC])
        {
            TradePswdView *view = [[TradePswdView alloc]initWithFrame:self.navigationController.view.frame];
            [self.navigationController.view addSubview:view];
            [view showView];
            view.block = ^(NSString *tradePswd){
                if (coupons.length == 0) coupons = @"";
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/purchase"];
                NSLog(@"%@",coupons);
                NSDictionary *parameter = @{@"investAmount":investAmount,
                                            @"tradePassword":tradePswd,
                                            @"useZtbBalance":@"true",
                                            @"coupons":coupons,
                                            @"isValidate":@"false",
                                            @"idOrCode":idOrCode,
                                            @"vouchers":vouchers};
                [manager POST:URL parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
                        else
                        {
                            hud.labelText = [responseObject objectForKey:@"errorMessage"];
                        }
                    }
                    else
                    {
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"抢购成功";
                        [hud hide:YES afterDelay:1.5f];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (self.isFromNewer)
                            {
                                [[self navigationController]popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                            }
                            else
                            {
                                [[self navigationController]popToRootViewControllerAnimated:YES];
                            }
                        });
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"当前网络状况不佳，请重试";
                    [hud hide:YES afterDelay:1.5f];
                }];
                
            };
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
    if (coupons.length == 0) coupons = @"";
    if (vouchers.length == 0) vouchers = @"";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/purchase"];
    NSLog(@"%@",coupons);
    NSDictionary *parameter = @{@"investAmount":investAmount,
                                @"tradePassword":tradePswd,
                                @"useZtbBalance":@"true",
                                @"coupons":coupons,
                                @"isValidate":@"false",
                                @"idOrCode":idOrCode,
                                };
    [manager POST:URL parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
            else
            {
                hud.labelText = [responseObject objectForKey:@"errorMessage"];
            }
        }
        else
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"抢购成功";
            [hud hide:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.isFromNewer)
                {
                    [[self navigationController]popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
                else
                {
                    [[self navigationController]popToRootViewControllerAnimated:YES];
                }
            });
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];

}


@end
