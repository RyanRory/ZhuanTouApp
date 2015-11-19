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
    wenjianPTNumLabel.text = [NSString stringWithFormat:@"%d个月",((NSString*)[productInfo objectForKey:@"noOfDays"]).intValue/30];
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
    productTimeNumLabel.text = [NSString stringWithFormat:@"%d个月",(int)round((((NSString*)[productInfo objectForKey:@"noOfDays"]).doubleValue / 30))];
    amountNumLabel.text = [NSString stringWithFormat:@"%@元",[NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithInt:investAmount.intValue]]]];
}

- (void)confirm:(id)sender
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
            hud.labelText = [responseObject objectForKey:@"errorMessage"];
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"抢购成功";
            [hud hide:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[self navigationController]popToRootViewControllerAnimated:YES];
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
