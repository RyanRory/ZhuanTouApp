//
//  DrawViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/1.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "DrawViewController.h"

@interface DrawViewController ()

@end

@implementation DrawViewController

@synthesize editView, editTextField, descriptionLabel, drawNumLabel, confirmButton, drawCostLabel, drawCostDescriptionLabel, noFeeLabel, drawPreTimeLabel;
@synthesize bankCardView, bankImageView, bankNameLabel, cardNumLabel, branchLabel;
@synthesize noBankCardView, bankLabel, bankcardNoTextField, branchTextField, balanceLabel, chooseProvinceButton, chooseCityButton, chooseBankButton, provinceLabel, cityLabel, NBCVconfirmButton, NBCVnoFeeNumLabel, drawNumTextField, phoneNumLabel, smsCodeTextField, getSmsCodeButton, preTimeLabel, costLabel;

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
    descriptionLabel.hidden = YES;
    drawNumLabel.hidden = YES;
    editView.hidden = YES;
    confirmButton.hidden = YES;
    noBankCardView.hidden = YES;
    noFeeLabel.hidden = YES;
    drawPreTimeLabel.hidden = YES;
    drawCostLabel.hidden = YES;
    drawCostDescriptionLabel.hidden = YES;
    
    SCNumberKeyBoard *keyboard = [SCNumberKeyBoard showWithTextField:editTextField enter:nil close:nil];
    [keyboard.enterButton setBackgroundColor:ZTBLUE];
    [keyboard.enterButton setTitle:@"确定" forState:UIControlStateNormal];
    
    //NoBankCardView
    [NBCVconfirmButton setUserInteractionEnabled:NO];
    [NBCVconfirmButton setAlpha:0.6f];
    [NBCVconfirmButton addTarget:self action:@selector(NBCVconfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [chooseBankButton addTarget:self action:@selector(showChooseDetail:) forControlEvents:UIControlEventTouchUpInside];
    [chooseProvinceButton addTarget:self action:@selector(showChooseDetail:) forControlEvents:UIControlEventTouchUpInside];
    [chooseCityButton addTarget:self action:@selector(showChooseDetail:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    bankTemp = provinceTemp = cityTemp = 0;
    
    [self.navigationController.view addSubview:bgView];
    [self.navigationController.view addSubview:view];
    
    bankArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankList" ofType:@"plist"]];
    provinceArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"provinceList" ofType:@"plist"]];
    
    SCNumberKeyBoard *keyboard2 = [SCNumberKeyBoard showWithTextField:drawNumTextField enter:nil close:nil];
    [keyboard2.enterButton setBackgroundColor:ZTBLUE];
    [keyboard2.enterButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [getSmsCodeButton.layer setBorderColor:ZTBLUE.CGColor];
    getSmsCodeButton.layer.borderWidth = 1;
    getSmsCodeButton.layer.cornerRadius = 3;
    [getSmsCodeButton addTarget:self action:@selector(getSmsCode:) forControlEvents:UIControlEventTouchUpInside];
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
                bankImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[responseObject[0] objectForKey:@"imgUrl"]]]];
                confirmButton.hidden = NO;
                descriptionLabel.hidden = NO;
                drawNumLabel.hidden = NO;
                editView.hidden = NO;
                noFeeLabel.hidden = NO;
                drawPreTimeLabel.hidden = NO;
                drawCostLabel.hidden = NO;
                drawCostDescriptionLabel.hidden = NO;
            }
            else
            {
                noBankCardView.hidden = NO;
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                phoneNumLabel.text = [NSString stringWithFormat:@"将向您的%@手机发送验证码：", [userDefault objectForKey:CURRENTPHONE]];
                bankcardNoTextField.text = [responseObject[0] objectForKey:@"cardCode"];
                bankLabel.text = [responseObject[0] objectForKey:@"bankName"];
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
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"朕知道了" style:UIAlertActionStyleCancel handler:nil];
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
                hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"当前网络状况不佳，请重试";
                [hud hide:YES afterDelay:1.5f];
            }];

            noBankCardView.hidden = NO;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            phoneNumLabel.text = [NSString stringWithFormat:@"将向您的%@手机发送验证码：", [userDefault objectForKey:CURRENTPHONE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];

    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    NSString *URL1 = [BASEURL stringByAppendingString:@"api/account/userWithdrawVm4M"];
    [manager1 GET:URL1 parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject1) {
        NSLog(@"%@", responseObject1);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00"];
        drawNumLabel.text = [NSString stringWithFormat:@"%@元",[NSString stringWithString:[formatter stringFromNumber:[responseObject1 objectForKey:@"fundsAvailable"]]]];
        noFeeLabel.text = [NSString stringWithFormat:@"(每月可免费提现3次，本月剩余免费提现次数:%@次)",[responseObject1 objectForKey:@"freeWithdrawsThisMonth"]];
        balanceLabel.text = [NSString stringWithFormat:@"%@元",[NSString stringWithString:[formatter stringFromNumber:[responseObject1 objectForKey:@"fundsAvailable"]]]];
        NBCVnoFeeNumLabel.text = [NSString stringWithFormat:@"(每月可免费提现3次，本月剩余免费提现次数:%@次)",[responseObject1 objectForKey:@"freeWithdrawsThisMonth"]];
        if ([NSString stringWithFormat:@"%@",[responseObject1 objectForKey:@"freeWithdrawsThisMonth"]].intValue == 0)
        {
            costLabel.text = @"3元";
            drawCostLabel.text = @"3元";
        }
        else
        {
            costLabel.text = @"0元";
            drawCostLabel.text = @"0元";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
    
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
    NSString *URL2 = [BASEURL stringByAppendingString:@"api/withdraw/confirmDate"];
    [manager2 GET:URL2 parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        preTimeLabel.text = [NSString stringWithFormat:@"预计到账时间：%@", [responseObject objectForKey:@"dateDesc"]];
        drawPreTimeLabel.text = [NSString stringWithFormat:@"预计到账时间：%@", [responseObject objectForKey:@"dateDesc"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];

}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm:(id)sender
{
    double num = [drawNumLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""].doubleValue;
    if (editTextField.text.doubleValue > num)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"超出当前账户余额";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [editTextField becomeFirstResponder];
        });
    }
    else if (editTextField.text.doubleValue < 100)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"提现金额不低于100元";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [editTextField becomeFirstResponder];
        });
    }
    else if (!(branchLabel.text.length > 0))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了您的资金安全，需补充银行卡的以下信息后才能提现。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"朕知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            CompleteBankCardInfoViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"CompleteBankCardInfoViewController"];
            vc.bankNameLabel.text = bankNameLabel.text;
            vc.bankCardNoLabel.text = cardNumLabel.text;
            vc.amount = editTextField.text;
            [[self navigationController]pushViewController:vc animated:YES];
        }];
        [alertController addAction:confirmAction];
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
            [self draw:tradePswdTextField.text];
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

- (void)draw:(NSString*)tradePswd
{
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/withdraw/applyWithdrawAndBindCard"];
    NSDictionary *parameter;
    if (noBankCardView.hidden)
    {
        parameter = @{@"withdrawAmount": editTextField.text,
                      @"tradePassword": tradePswd};
    }
    else
    {
        parameter = @{@"province": provinceLabel.text,
                      @"city": cityLabel.text,
                      @"cardCode": bankcardNoTextField.text,
                      @"bankCode": [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankCodeList" ofType:@"plist"]] objectForKey:bankLabel.text],
                      @"subbranchName": branchTextField.text,
                      @"withdrawAmount": drawNumTextField.text,
                      @"tradePassword": tradePswd,
                      @"smsCode": smsCodeTextField.text};
    }
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
            hud.labelText = @"提现申请成功";
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

-(IBAction)textFiledReturnEditing:(UITextField*)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [editTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((editTextField.text.length > 0) && (editTextField.text.length > 0))
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

- (IBAction)NBCVconfirmButtonEnableListener:(id)sender
{
    if ((branchTextField.text.length > 0) && (bankcardNoTextField.text.length > 0) && (smsCodeTextField.text.length > 0) && (![bankLabel.text isEqualToString:@"请选择"]) && (![provinceLabel.text isEqualToString:@"请选择"]) && (![cityLabel.text isEqualToString:@"请选择"]) && (drawNumTextField.text.length > 0))
    {
        [NBCVconfirmButton setUserInteractionEnabled:YES];
        [NBCVconfirmButton setAlpha:1.0f];
    }
    else
    {
        [NBCVconfirmButton setUserInteractionEnabled:NO];
        [NBCVconfirmButton setAlpha:0.6f];
    }
}

#pragma NoBankCardView

- (void)NBCVconfirm:(id)sender
{
    [bankcardNoTextField resignFirstResponder];
    [branchTextField resignFirstResponder];
    [smsCodeTextField resignFirstResponder];
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *cardReg = @"^[0-9]{16,30}$";
    NSPredicate *regextestId = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardReg];
    
    if(![regextestId evaluateWithObject: bankcardNoTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请检查您的银行卡号码是否正确";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [bankcardNoTextField becomeFirstResponder];
        });
    }
    else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{4}$"] evaluateWithObject:smsCodeTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请检查验证码是否正确";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [smsCodeTextField becomeFirstResponder];
        });
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
            [self draw:tradePswdTextField.text];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        confirmAction.enabled = NO;
        [self presentViewController:alertController animated:YES completion:nil];

    }

}

- (void)showChooseDetail:(UIButton*)sender
{
    [bankcardNoTextField resignFirstResponder];
    [branchTextField resignFirstResponder];
    [smsCodeTextField resignFirstResponder];
    
    if (sender == chooseBankButton)
    {
        buttonTag = 0;
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
    else if (sender == chooseProvinceButton)
    {
        buttonTag = 1;
        NSTimeInterval animationDuration = 0.30f;
        bgView.hidden = NO;
        [UIView beginAnimations:@"ResizeForPickerView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        bgView.alpha = 1.0;
        view.frame = CGRectMake(0, self.navigationController.view.frame.size.height-224, self.navigationController.view.frame.size.width, 224);
        [UIView commitAnimations];
        NSLog(@"%d",provinceTemp);
        
        [picker selectRow:provinceTemp inComponent:0 animated:NO];
        
        [picker reloadAllComponents];
    }
    else
    {
        if ([provinceLabel.text isEqualToString:@"请选择"])
        {
            hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"请先选择省份";
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
            buttonTag = 2;
            NSTimeInterval animationDuration = 0.30f;
            bgView.hidden = NO;
            [UIView beginAnimations:@"ResizeForPickerView" context:nil];
            [UIView setAnimationDuration:animationDuration];
            bgView.alpha = 1.0;
            view.frame = CGRectMake(0, self.navigationController.view.frame.size.height-224, self.navigationController.view.frame.size.width, 224);
            [UIView commitAnimations];
            cityArray = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"]] objectForKey:provinceLabel.text];
            [picker selectRow:cityTemp inComponent:0 animated:NO];
            
            [picker reloadAllComponents];
        }
    }
}

- (void)getSmsCode:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *isYuyin;
    if ([getSmsCodeButton.titleLabel.text isEqualToString:@"语音验证"])
    {
        isYuyin = @"/true";
    }
    else
    {
        isYuyin = @"";
    }
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/withdraw/sendAddSms%@",isYuyin]];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f = str.intValue;
        if (f == 0)
        {
            hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = [responseObject objectForKey:@"errorMessage"];
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
            secondsCountDown = 60;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            [getSmsCodeButton setUserInteractionEnabled:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"获取短信验证码失败，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];

}

- (void)timeFireMethod
{
    secondsCountDown--;
    if (secondsCountDown == 0)
    {
        getSmsCodeButton.titleLabel.text = @"语音验证";
        [getSmsCodeButton setTitle:@"语音验证" forState:UIControlStateNormal];
        [getSmsCodeButton setUserInteractionEnabled:YES];
        [countDownTimer invalidate];
    }
    else
    {
        getSmsCodeButton.titleLabel.text = [NSString stringWithFormat:@"(%d)秒后重新获取",secondsCountDown];
        [getSmsCodeButton setTitle:[NSString stringWithFormat:@"(%d)秒后重新获取",secondsCountDown] forState:UIControlStateNormal];
    }
}


#pragma UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (buttonTag == 0)
    {
        return bankArray.count;
    }
    else if (buttonTag == 1)
    {
        return provinceArray.count;
    }
    else
    {
        return cityArray.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (buttonTag == 0)
    {
        return [bankArray objectAtIndex:row];
    }
    else if (buttonTag == 1)
    {
        return [provinceArray objectAtIndex:row];
    }
    else
    {
        return [cityArray objectAtIndex:row];;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (buttonTag == 0)
    {
        bankTemp = (int)row;
    }
    else if (buttonTag == 1)
    {
        provinceTemp = (int)row;
    }
    else
    {
        cityTemp = (int)row;
    }
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
    if (buttonTag == 0)
    {
        bankLabel.text = [bankArray objectAtIndex:bankTemp];
        bankLabel.textColor = ZTGRAY;
    }
    else if (buttonTag == 1)
    {
        if (![provinceLabel.text isEqualToString:[provinceArray objectAtIndex:provinceTemp]])
        {
            cityTemp = 0;
            cityLabel.text = @"请选择";
            cityLabel.textColor = ZTLIGHTGRAY;
        }
        provinceLabel.text = [provinceArray objectAtIndex:provinceTemp];
        provinceLabel.textColor = ZTGRAY;
    }
    else
    {
        cityLabel.text = [cityArray objectAtIndex:cityTemp];
        cityLabel.textColor = ZTGRAY;
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
