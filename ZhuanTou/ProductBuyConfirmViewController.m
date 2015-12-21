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

@synthesize confirmButton, contentView, wenjianView;
@synthesize bgView;
@synthesize preIncomeLabel, preIncomeNumLabel, productTimeLabel, productTimeNumLabel, lowestIncomeLabel, lowestIncomeNumLabel, amountNumLabel, amoutLabel;
@synthesize wenjianBgView, wenjianAmountLabel, wenjianAmountNumLabel, wenjianPILabel, wenjianPINumLabel, wenjianPTLabel, wenjianPTNumLabel;
@synthesize investAmount, coupons, idOrCode, productInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    contentView.layer.cornerRadius = 3;
    confirmButton.layer.cornerRadius = 3;
    wenjianView.layer.cornerRadius = 3;
    
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [contentView setHidden:YES];
    wenjianBgView.backgroundColor = ZTLIGHTRED;
    confirmButton.backgroundColor = ZTLIGHTRED;
    wenjianPILabel.textColor = ZTLIGHTRED;
    wenjianPINumLabel.textColor = ZTLIGHTRED;
    wenjianPTLabel.textColor = ZTLIGHTRED;
    wenjianPTNumLabel.textColor = ZTLIGHTRED;
    wenjianAmountLabel.textColor = ZTLIGHTRED;
    wenjianAmountNumLabel.textColor = ZTLIGHTRED;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0"];
    wenjianPINumLabel.text = [NSString stringWithFormat:@"%@%%",[productInfo objectForKey:@"interestRate"]];
    wenjianPTNumLabel.text = [NSString stringWithFormat:@"%d天",(((NSString*)[productInfo objectForKey:@"noOfDays"]).intValue)];
    wenjianAmountNumLabel.text = [NSString stringWithFormat:@"%@元",[NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithInt:investAmount.intValue]]]];
    
}

- (void)setupZonghe
{
    [wenjianView setHidden:YES];
    bgView.backgroundColor = ZTBLUE;
    confirmButton.backgroundColor = ZTBLUE;
    preIncomeLabel.textColor = ZTBLUE;
    preIncomeNumLabel.textColor = ZTBLUE;
    productTimeLabel.textColor = ZTBLUE;
    productTimeNumLabel.textColor = ZTBLUE;
    lowestIncomeLabel.textColor = ZTBLUE;
    lowestIncomeNumLabel.textColor = ZTBLUE;
    amoutLabel.textColor = ZTBLUE;
    amountNumLabel.textColor = ZTBLUE;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0"];
    preIncomeNumLabel.text = [NSString stringWithFormat:@"%@%%",[productInfo objectForKey:@"expectedReturn"]];
    lowestIncomeNumLabel.text = [NSString stringWithFormat:@"%@%%",[productInfo objectForKey:@"interestRate"]];
    productTimeNumLabel.text = [NSString stringWithFormat:@"%d天",(((NSString*)[productInfo objectForKey:@"noOfDays"]).intValue)];
    amountNumLabel.text = [NSString stringWithFormat:@"%@元",[NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithInt:investAmount.intValue]]]];
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/purchase"];
    NSDictionary *parameter = @{@"investAmount":investAmount,
                                @"tradePassword":tradePswd,
                                @"useZtbBalance":@"true",
                                @"coupons":coupons,
                                @"isValidate":@"false",
                                @"idOrCode":idOrCode};
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
//            hud.mode = MBProgressHUDModeCustomView;
//            hud.labelText = @"抢购成功";
//            [hud hide:YES afterDelay:1.5f];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (self.isFromNewer)
//                {
//                    [[self navigationController]popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//                }
//                else
//                {
//                    [[self navigationController]popToRootViewControllerAnimated:YES];
//                }
//            });
            [hud hide:YES];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"抢购成功" message:[NSString stringWithFormat:@"您的资金将暂时锁定在专投宝中，享受专投宝利息，并在%@产品开始操盘后转入在投资产", [productInfo objectForKey:@"beginDate"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                if (self.isFromNewer)
                {
                    [[self navigationController]popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
                else
                {
                    [[self navigationController]popToRootViewControllerAnimated:YES];
                }

            }];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];

}


@end
