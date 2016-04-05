//
//  ChargeViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/1.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ChargeViewController.h"

@interface ChargeViewController ()

@end

@implementation ChargeViewController

@synthesize editView, editTextField, confirmButton;
@synthesize bankCardView, bankImageView, bankNameLabel, cardNumLabel, branchLabel, oneLimitLabel, dayLimitLabel;
@synthesize noBankCardView, bankcardDetailButton, bankcardNoTextField, bankLabel, limitLabel, chooseBankButton, phoneNumTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    confirmButton.layer.cornerRadius = 3;
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [bankCardView.layer setBorderWidth:1.0f];
    [bankCardView.layer setBorderColor:[UIColor colorWithRed:56.0/255.0 green:148.0/255.0 blue:238.0/255.0 alpha:100].CGColor];
    bankCardView.layer.cornerRadius = 3;
    
    bankCardView.hidden = YES;
    editView.hidden = YES;
    confirmButton.hidden = YES;
    noBankCardView.hidden = YES;
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height, self.navigationController.view.frame.size.width, 224)];
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    bgView.hidden = YES;
    bgView.alpha = 0;
    
    picker = [[UIPickerView alloc] init];
    picker.backgroundColor = [UIColor whiteColor];
    picker.frame = CGRectMake(0, view.frame.size.height - 180, view.frame.size.width, 180);
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    
    [view addSubview:picker];
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 224, view.frame.size.width, 44)];
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(OKButton:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CancelButton:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = [NSArray arrayWithObjects:cancelButton, flexibleSpace, okButton, nil];
    
    [view addSubview:toolBar];
    [self.navigationController.view addSubview:bgView];
    [self.navigationController.view addSubview:view];
    
    bankArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankList" ofType:@"plist"]];
    
    [chooseBankButton addTarget:self action:@selector(showChooseDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    SCNumberKeyBoard *keyboard = [SCNumberKeyBoard showWithTextField:editTextField enter:nil close:nil];
    [keyboard.enterButton setBackgroundColor:ZTBLUE];
    [keyboard.enterButton setTitle:@"确定" forState:UIControlStateNormal];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/charge/singleLimitMap"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        dailyLimit = [NSDictionary dictionaryWithDictionary:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    if (bankCardView.hidden)
    {
        [self setupData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    picker.delegate = nil;
    picker.dataSource = nil;
}

- (void)setupData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/getAppBankCards"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        if (responseObject.count > 0)
        {
            if ([NSString stringWithFormat:@"%@", [responseObject[0] objectForKey:@"isValidated"]].boolValue)
            {
                bankCardView.hidden = NO;
                noBankCardView.hidden = YES;
                bankNameLabel.text = [responseObject[0] objectForKey:@"bankName"];
                if ([[responseObject[0] objectForKey:@"subBankName"] isKindOfClass:[NSNull class]])
                {
                    branchLabel.text = @"";
                }
                else
                {
                    branchLabel.text = [[responseObject[0] objectForKey:@"subBankName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
                cardNumLabel.text = [responseObject[0] objectForKey:@"cardCodeDisplay"];
                oneLimitLabel.text = [responseObject[0] objectForKey:@"limitAmount"];
                dayLimitLabel.text = [responseObject[0] objectForKey:@"dailyLimit"];
                bankImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[responseObject[0] objectForKey:@"imgUrl"]]]];
            }
            else
            {
                bankCardView.hidden = YES;
                noBankCardView.hidden = NO;
                bankcardNoTextField.text = [responseObject[0] objectForKey:@"cardCode"];
                bankLabel.text = [responseObject[0] objectForKey:@"bankName"];
                bankLabel.textColor = ZTGRAY;
                if ([[responseObject[0] objectForKey:@"limitAmount"] isEqualToString:@"无限额"])
                {
                    limitLabel.text = [NSString stringWithFormat:@"(单笔无限额)"];
                }
                else
                {
                    limitLabel.text = [NSString stringWithFormat:@"(单笔限额%@元)", [responseObject[0] objectForKey:@"limitAmount"]];
                }
                //下个版本bug修正！！！目前bindedmobile字段为空会导致页面崩溃
                if (![[responseObject[0] objectForKey:@"bindedMobile"] isKindOfClass:[NSNull class]])
                {
                    phoneNumTextField.text = [responseObject[0] objectForKey:@"bindedMobile"];
                }
            }
        }
        else
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *URL = [BASEURL stringByAppendingString:@"api/account/IsIdentified"];
            [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                NSLog(@"%@",responseObject);
                NSString *str = [responseObject objectForKey:@"isSuccess"];
                int f1 = str.intValue;
                if (f1 == 1)
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了您的资金安全，您的资金将被限制同卡进出，请填写真实银行卡信息。" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:confirmAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还未进行实名验证，请先进行实名验证" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                        [[self navigationController] popViewControllerAnimated:YES];
                    }];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        RealNameViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RealNameViewController"];
                        [[self navigationController]pushViewController:vc animated:YES];
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:confirmAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"当前网络状况不佳，请重试";
                [hud hide:YES afterDelay:1.5f];
            }];

            bankCardView.hidden = YES;
            noBankCardView.hidden = NO;
        }
        confirmButton.hidden = NO;
        editView.hidden = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.isFromUserCenter)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)confirm:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if (noBankCardView.hidden)
    {
        NSString *s = oneLimitLabel.text;
        s = [s stringByReplacingOccurrencesOfString:@"," withString:@""];
        if ((s.doubleValue < editTextField.text.doubleValue) && (![oneLimitLabel.text isEqualToString:@"无限额"]))
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"超过单笔限额";
            [hud hide:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [editTextField becomeFirstResponder];
            });
        }
        else
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *URL = [BASEURL stringByAppendingString:@"account/RenzhengSDKCharge"];
            NSDictionary *parameter = @{@"txn_amt":[NSString stringWithFormat:@"%.2f",editTextField.text.doubleValue]};
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSLog(@"%@",parameter);
            [manager POST:URL parameters:parameter success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"%@", dict);
                if ([[dict objectForKey:@"retCode"] isEqualToString:@"0000"])
                {
                    [hud hide:YES];
                    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"chargeChannel"]] isEqualToString:@"宝付"])
                    {
                        BaoFooPayController*web = [[BaoFooPayController alloc] init];
                        NSDictionary *baofooData = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"baofoodata"]];
                        web.PAY_TOKEN = [baofooData objectForKey:@"tradeNo"];
                        web.delegate = self;
                        web.PAY_BUSINESS = @"true";
                        [self presentViewController:web animated:YES completion:nil];
                        [confirmButton setUserInteractionEnabled:YES];
                        [confirmButton setAlpha:1.0f];
                    }
                    else
                    {
                        NSArray *array = [str componentsSeparatedByString:@"\"risk_item\":"];
                        NSArray *array2 = [array[1] componentsSeparatedByString:@"},"];
                        NSString *risk_item_str = [NSString stringWithFormat:@"%@}",array2[0]];
                        NSLog(@"%@",risk_item_str);
                        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"lianliandata"]];
                        NSMutableDictionary *lianlianData = [[NSMutableDictionary alloc]init];
                        [lianlianData setValue:[tempData objectForKey:@"acct_name"] forKey:@"acct_name"];
                        [lianlianData setValue:[tempData objectForKey:@"busi_partner"] forKey:@"busi_partner"];
                        [lianlianData setValue:[tempData objectForKey:@"card_no"] forKey:@"card_no"];
                        [lianlianData setValue:[tempData objectForKey:@"dt_order"] forKey:@"dt_order"];
                        [lianlianData setValue:[tempData objectForKey:@"id_no"] forKey:@"id_no"];
                        [lianlianData setValue:[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[tempData objectForKey:@"money_order"]].doubleValue] forKey:@"money_order"];
                        [lianlianData setValue:[tempData objectForKey:@"name_goods"] forKey:@"name_goods"];
                        [lianlianData setValue:[tempData objectForKey:@"no_agree"] forKey:@"no_agree"];
                        [lianlianData setValue:[tempData objectForKey:@"no_order"] forKey:@"no_order"];
                        [lianlianData setValue:[tempData objectForKey:@"notify_url"] forKey:@"notify_url"];
                        [lianlianData setValue:[tempData objectForKey:@"oid_partner"] forKey:@"oid_partner"];
                        [lianlianData setValue:risk_item_str forKey:@"risk_item"];
                        [lianlianData setValue:[tempData objectForKey:@"sign"] forKey:@"sign"];
                        [lianlianData setValue:[tempData objectForKey:@"sign_type"] forKey:@"sign_type"];
                        [lianlianData setValue:[tempData objectForKey:@"user_id"] forKey:@"user_id"];
                        [lianlianData setValue:[tempData objectForKey:@"valid_order"] forKey:@"valid_order"];
                        NSLog(@"%@",lianlianData);
                        [LLPaySdk sharedSdk].sdkDelegate = self;
                        [[LLPaySdk sharedSdk] presentVerifyPaySdkInViewController:self withTraderInfo:lianlianData];
                        [confirmButton setUserInteractionEnabled:YES];
                        [confirmButton setAlpha:1.0f];
                    }
                }

                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"当前网络状态不佳，请稍后重试";
                [hud hide:YES afterDelay:1.0f];
            }];

        }
    }
    else
    {
        hud.mode = MBProgressHUDModeIndeterminate;
        
        NSString *cardReg = @"^[0-9]{16,30}$";
        NSPredicate *regextestId = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardReg];
        NSString *limit = [NSString stringWithFormat:@"%@",[dailyLimit objectForKey:[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankCodeList" ofType:@"plist"]] objectForKey:bankLabel.text] lowercaseString]]];
        limit = [limit stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if(![regextestId evaluateWithObject: bankcardNoTextField.text])
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"请检查您的银行卡号码是否正确";
            [hud hide:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [bankcardNoTextField becomeFirstResponder];
            });
        }
        else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{11}$"] evaluateWithObject:phoneNumTextField.text])
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"请检查手机号码是否正确";
            [hud hide:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [phoneNumTextField becomeFirstResponder];
            });
        }
        else if (!([limit isEqualToString:@"无限额"] || limit.doubleValue >= editTextField.text.doubleValue))
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"超过单笔限额";
            [hud hide:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [editTextField becomeFirstResponder];
            });
        }
        else
        {
            [confirmButton setUserInteractionEnabled:NO];
            [confirmButton setAlpha:0.6f];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *URL = [BASEURL stringByAppendingString:@"account/RenzhengSDKCharge"];
            NSDictionary *parameter = @{@"txn_amt":[NSString stringWithFormat:@"%.2f",editTextField.text.doubleValue],
                                        @"CardCode":bankcardNoTextField.text,
                                        @"BankCode":[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankCodeList" ofType:@"plist"]] objectForKey:bankLabel.text],
                                        @"MobilePhone":phoneNumTextField.text};
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSLog(@"%@",parameter);
            [manager POST:URL parameters:parameter success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"%@", dict);
                if ([[dict objectForKey:@"retCode"] isEqualToString:@"0000"])
                {
                    [hud hide:YES];
                    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"chargeChannel"]] isEqualToString:@"宝付"])
                    {
                        BaoFooPayController*web = [[BaoFooPayController alloc] init];
                        NSDictionary *baofooData = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"baofoodata"]];
                        web.PAY_TOKEN = [baofooData objectForKey:@"tradeNo"];
                        web.delegate = self;
                        web.PAY_BUSINESS = @"true";
                        [self presentViewController:web animated:YES completion:nil];
                        [confirmButton setUserInteractionEnabled:YES];
                        [confirmButton setAlpha:1.0f];
                    }
                    else
                    {
                        NSArray *array = [str componentsSeparatedByString:@"\"risk_item\":"];
                        NSArray *array2 = [array[1] componentsSeparatedByString:@"},"];
                        NSString *risk_item_str = [NSString stringWithFormat:@"%@}",array2[0]];
                        NSLog(@"%@",risk_item_str);
                        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"lianliandata"]];
                        NSMutableDictionary *lianlianData = [[NSMutableDictionary alloc]init];
                        [lianlianData setValue:[tempData objectForKey:@"acct_name"] forKey:@"acct_name"];
                        [lianlianData setValue:[tempData objectForKey:@"busi_partner"] forKey:@"busi_partner"];
                        [lianlianData setValue:[tempData objectForKey:@"card_no"] forKey:@"card_no"];
                        [lianlianData setValue:[tempData objectForKey:@"dt_order"] forKey:@"dt_order"];
                        [lianlianData setValue:[tempData objectForKey:@"id_no"] forKey:@"id_no"];
                        [lianlianData setValue:[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[tempData objectForKey:@"money_order"]].doubleValue] forKey:@"money_order"];
                        [lianlianData setValue:[tempData objectForKey:@"name_goods"] forKey:@"name_goods"];
                        [lianlianData setValue:[tempData objectForKey:@"no_agree"] forKey:@"no_agree"];
                        [lianlianData setValue:[tempData objectForKey:@"no_order"] forKey:@"no_order"];
                        [lianlianData setValue:[tempData objectForKey:@"notify_url"] forKey:@"notify_url"];
                        [lianlianData setValue:[tempData objectForKey:@"oid_partner"] forKey:@"oid_partner"];
                        [lianlianData setValue:risk_item_str forKey:@"risk_item"];
                        [lianlianData setValue:[tempData objectForKey:@"sign"] forKey:@"sign"];
                        [lianlianData setValue:[tempData objectForKey:@"sign_type"] forKey:@"sign_type"];
                        [lianlianData setValue:[tempData objectForKey:@"user_id"] forKey:@"user_id"];
                        [lianlianData setValue:[tempData objectForKey:@"valid_order"] forKey:@"valid_order"];
                        NSLog(@"%@",lianlianData);
                        [LLPaySdk sharedSdk].sdkDelegate = self;
                        [[LLPaySdk sharedSdk] presentVerifyPaySdkInViewController:self withTraderInfo:lianlianData];
                        [confirmButton setUserInteractionEnabled:YES];
                        [confirmButton setAlpha:1.0f];
                    }
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"当前网络状态不佳，请稍后重试";
                [hud hide:YES afterDelay:1.0f];
            }];

        }

    }
}

-(IBAction)textFiledReturnEditing:(UITextField*)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [editTextField resignFirstResponder];
    [bankcardNoTextField resignFirstResponder];
    [phoneNumTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if (noBankCardView.hidden)
    {
        if (editTextField.text.length > 0)
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
    else
    {
        if ((editTextField.text.length > 0) && (phoneNumTextField.text.length > 0) && (bankcardNoTextField.text.length > 0) && (![bankLabel.text isEqualToString:@"请选择"]))
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
}

- (void)showChooseDetail:(UIButton*)sender
{
    [bankcardNoTextField resignFirstResponder];
    [editTextField resignFirstResponder];
    [phoneNumTextField resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    bgView.hidden = NO;
    [UIView beginAnimations:@"ResizeForPickerView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    bgView.alpha = 1.0;
    view.frame = CGRectMake(0, self.navigationController.view.frame.size.height-224, self.navigationController.view.frame.size.width, 224);
    [UIView commitAnimations];
    
    [picker selectRow:bankTemp inComponent:0 animated:NO];
    
    [picker reloadAllComponents];
}


#pragma mark - BaofooDelegate
-(void)callBack:(NSString*)params
{
    NSString *str = [params substringToIndex:1];
    if ([str isEqualToString:@"1"])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"支付成功";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self navigationController] popViewControllerAnimated:YES];
        });
    }
}

#pragma mark - LLPayDelegate
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                msg = @"支付成功";
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                msg = @"支付单处理中";
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                msg = @"支付单失败";
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail:
        {
            msg = @"支付失败";
        }
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
        }
            break;
        case kLLPayResultInitError:
        {
            msg = @"sdk初始化异常";
        }
            break;
        case kLLPayResultInitParamError:
        {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    if ([msg isEqualToString:@"支付成功"])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = msg;
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self navigationController] popViewControllerAnimated:YES];
        });
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = msg;
        [hud hide:YES afterDelay:1.5f];
    }

}


#pragma UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return bankArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [bankArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    bankTemp = (int)row;
}

- (void)OKButton:(id)sender
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForPickerView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    bgView.alpha = 0;
    view.frame = CGRectMake(0, self.navigationController.view.frame.size.height, self.navigationController.view.frame.size.width, 224);
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        bgView.hidden = YES;
    });
    
    bankLabel.text = [bankArray objectAtIndex:bankTemp];
    bankLabel.textColor = ZTGRAY;
    NSString *limit = [dailyLimit objectForKey:[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankCodeList" ofType:@"plist"]] objectForKey:bankLabel.text] lowercaseString]];
    if ([limit isEqualToString:@"无限额"])
    {
        limitLabel.text = [NSString stringWithFormat:@"(单笔无限额)"];
    }
    else
    {
        limitLabel.text = [NSString stringWithFormat:@"(单笔限额%@元)", limit];
    }
}

- (void)CancelButton:(id)sender
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForPickerView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    bgView.alpha = 0;
    view.frame = CGRectMake(0, self.navigationController.view.frame.size.height, self.navigationController.view.frame.size.width, 224);
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        bgView.hidden = YES;
    });
}



@end
