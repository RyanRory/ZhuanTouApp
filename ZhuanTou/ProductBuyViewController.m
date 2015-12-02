//
//  ProductBuyViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/16.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductBuyViewController.h"

@interface ProductBuyViewController ()

@end

@implementation ProductBuyViewController

@synthesize headBgView, balanceLabel, chargeButton;
@synthesize bgView, amountTextField, restLabel, contentView;
@synthesize noBonusLabel, checkboxButton, agreementButton, confirmButton;
@synthesize style;
@synthesize tView;
@synthesize idOrCode, bidableAmount, productInfo;

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
    
    contentView.layer.cornerRadius = 3;
    chargeButton.layer.cornerRadius = 3;
    confirmButton.layer.cornerRadius = 3;
    
    checkboxButton.selected = YES;
    [checkboxButton addTarget:self action:@selector(checkboxEnsure:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [agreementButton addTarget:self action:@selector(toAgreemet:) forControlEvents:UIControlEventTouchUpInside];
    [chargeButton addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
    
    tView.showsVerticalScrollIndicator = NO;
    tView.scrollEnabled = NO;
    tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tView.backgroundColor = [UIColor clearColor];
        
    if ([style isEqualToString:WENJIAN])
    {
        [self setupWenjian];
    }
    else if ([style isEqualToString:ZONGHE])
    {
        [self setupZonghe];
    }
    else
    {
        [self setupHuoqi];
    }
    
    restLabel.text = [NSString stringWithFormat:@"%@元",bidableAmount];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/couponInfo4M"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00"];
        if ([style isEqualToString:HUOQI])
        {
            balance = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"fundsAvailable"]].doubleValue;
            balanceLabel.text = [NSString stringWithFormat:@"可用余额：%@元",[formatter stringFromNumber:[responseObject objectForKey:@"fundsAvailable"]]];
        }
        else
        {
            balance = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"fundsAvailable"]].doubleValue + [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ztbBalance"]].doubleValue;
            balanceLabel.text = [NSString stringWithFormat:@"可投资余额：%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:balance]]];
        }
        datas = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"coupons"]];
        bonusNum = (int)datas.count;
        [tView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳";
        [hud hide:YES afterDelay:1.5f];
    }];
    
    SCNumberKeyBoard *keyboard = [SCNumberKeyBoard showWithTextField:amountTextField enter:nil close:nil];
    [keyboard.enterButton setBackgroundColor:ZTBLUE];
    [keyboard.enterButton setTitle:@"确定" forState:UIControlStateNormal];

}


- (void)viewDidAppear:(BOOL)animated
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    bgView.layer.mask = maskLayer;
    bgView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.title = @"购买稳盈宝";
    bgView.backgroundColor = ZTLIGHTRED;
    headBgView.backgroundColor = ZTLIGHTRED;
    confirmButton.backgroundColor = ZTLIGHTRED;
    chargeButton.tintColor = ZTLIGHTRED;
}

- (void)setupZonghe
{
    self.title = @"购买分红宝";
    bgView.backgroundColor = ZTBLUE;
    headBgView.backgroundColor = ZTBLUE;
    confirmButton.backgroundColor = ZTBLUE;
    chargeButton.tintColor = ZTBLUE;
}

- (void)setupHuoqi
{
    self.title = @"转入专投宝";
    bgView.backgroundColor = ZTRED;
    headBgView.backgroundColor = ZTRED;
    confirmButton.backgroundColor = ZTRED;
    chargeButton.tintColor = ZTRED;
    tView.hidden = YES;
    noBonusLabel.hidden = YES;
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
    if (amountTextField.text.doubleValue > balance)
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
//    else if ((![style isEqualToString:HUOQI]) && (amountTextField.text.intValue > ((NSString*)[productInfo objectForKey:@"maxPurchaseAmount"]).intValue))
//    {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.labelText = [NSString stringWithFormat:@"最高投资额度为%@元",[productInfo objectForKey:@"maxPurchaseAmount"]];
//        [hud hide:YES afterDelay:1.5];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [amountTextField becomeFirstResponder];
//        });
//    }
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
        else
        {
            ProductBuyConfirmViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyConfirmViewController"];
            [vc setStyle:style];
            vc.title = self.title;
            vc.investAmount = amountTextField.text;
            vc.coupons = coupons;
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

#pragma TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bonusNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 21;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [datas objectAtIndex:indexPath.row];
    static NSString *identifier = @"ProductBonusTableViewCell";
    ProductBonusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[ProductBonusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.checkboxButton.selected = NO;
    cell.checkboxButton.tag = indexPath.row;
    [cell.checkboxButton addTarget:self action:@selector(bonusCheckboxEnsure:) forControlEvents:UIControlEventTouchUpInside];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@-%@元", [data objectForKey:@"comments"], [data objectForKey:@"faceValue"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductBonusTableViewCell *cell = [tView cellForRowAtIndexPath:indexPath];
    if (amountTextField.text.doubleValue < [NSString stringWithFormat:@"%@",[[datas objectAtIndex:indexPath.row] objectForKey:@"thresholdValue"]].intValue)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"当前红包投资满%@元可用",[[datas objectAtIndex:indexPath.row] objectForKey:@"thresholdValue"]];
        [hud hide:YES afterDelay:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [amountTextField becomeFirstResponder];
        });
    }
    else
    {
        [self performSelector:@selector(bonusCheckboxEnsure:) withObject:cell.checkboxButton afterDelay:0];
    }
}

- (void)bonusCheckboxEnsure:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"checkIconActive.png"] forState:UIControlStateNormal];
        coupons = [coupons stringByAppendingString:[NSString stringWithFormat:@",%@",[[datas objectAtIndex:btn.tag] objectForKey:@"couponCode"]]];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"checkIcon.png"] forState:UIControlStateNormal];
        coupons = [coupons stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@",[[datas objectAtIndex:btn.tag] objectForKey:@"couponCode"]] withString:@""];
    }
    
}



@end
