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

@synthesize editView, editTextField, descriptionLabel, drawNumLabel, confirmButton, noFeeDescriptionLabel, noFeeNumLabel;
@synthesize bankCardView, bankImageView, bankNameLabel, cardNumLabel, branchLabel;
@synthesize noBankCardView, addBankCardButton;

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
    
    addBankCardButton.layer.cornerRadius = 3;
    [addBankCardButton addTarget:self action:@selector(toAddBankCard:) forControlEvents:UIControlEventTouchUpInside];
    
    bankCardView.hidden = YES;
    descriptionLabel.hidden = YES;
    drawNumLabel.hidden = YES;
    editView.hidden = YES;
    confirmButton.hidden = YES;
    noBankCardView.hidden = YES;
    addBankCardButton.hidden = YES;
    noFeeNumLabel.hidden = YES;
    noFeeDescriptionLabel.hidden = YES;
    
    SCNumberKeyBoard *keyboard = [SCNumberKeyBoard showWithTextField:editTextField enter:nil close:nil];
    [keyboard.enterButton setBackgroundColor:ZTBLUE];
    [keyboard.enterButton setTitle:@"确定" forState:UIControlStateNormal];
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

- (void)setupData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/getAppBankCards"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
//        NSString *str = [responseObject objectForKey:@"isSuccess"];
//        int f1 = str.intValue;
        if (responseObject.count > 0)
        {
            bankCardView.hidden = NO;
            bankNameLabel.text = [responseObject[0] objectForKey:@"bankName"];
            branchLabel.text = [[responseObject[0] objectForKey:@"subBankName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cardNumLabel.text = [responseObject[0] objectForKey:@"cardCode"];
            bankImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[responseObject[0] objectForKey:@"imgUrl"]]]];
            confirmButton.hidden = NO;
            descriptionLabel.hidden = NO;
            drawNumLabel.hidden = NO;
            editView.hidden = NO;
            noFeeDescriptionLabel.hidden = NO;
            noFeeNumLabel.hidden = NO;
            
            AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
            NSString *URL1 = [BASEURL stringByAppendingString:@"api/account/userWithdrawVm4M"];
            [manager1 GET:URL1 parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject1) {
                NSLog(@"%@", responseObject);
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                [formatter setPositiveFormat:@"###,##0.00"];
                drawNumLabel.text = [NSString stringWithFormat:@"%@元",[NSString stringWithString:[formatter stringFromNumber:[responseObject1 objectForKey:@"fundsAvailable"]]]];
                noFeeNumLabel.text = [NSString stringWithFormat:@"%@次",[responseObject1 objectForKey:@"freeWithdrawsThisMonth"]];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"当前网络状况不佳，请重试";
                [hud hide:YES afterDelay:1.5f];
            }];
        }
        else
        {
            noBankCardView.hidden = NO;
            addBankCardButton.hidden = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];


}

- (void)toAddBankCard:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/IsIdentified"];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            [hud hide:YES];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了您的资金安全，您的资金将被限制同卡进出，请填写真实银行卡信息。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                AddBankCardViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"AddBankCardViewController"];
                [vc setFullName:[responseObject objectForKey:@"fullName"]];
                [[self navigationController]pushViewController:vc animated:YES];
            }];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"您还未进行实名验证，请先进行实名验证";
            [hud hide:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                RealNameViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RealNameViewController"];
                [[self navigationController]pushViewController:vc animated:YES];
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

- (void)confirm:(id)sender
{
    double num = [drawNumLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""].doubleValue;
    if (editTextField.text.doubleValue > num)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"超出当前账户余额";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [editTextField becomeFirstResponder];
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/withdraw/applyWithdrawal4M"];
    NSDictionary *parameter = @{@"amount":editTextField.text,
                                @"tradePassword":tradePswd,
                                @"channel":@2,
                                @"transferAccount":@"self"};
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

-(IBAction)textFiledReturnEditing:(id)sender {
    [editTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [editTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((editTextField.text.length > 0) && (editTextField.text.doubleValue >= 100.00))
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
