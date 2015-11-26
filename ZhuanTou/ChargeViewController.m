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
    editView.hidden = YES;
    confirmButton.hidden = YES;
    noBankCardView.hidden = YES;
    addBankCardButton.hidden = YES;
    
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
            addBankCardButton.hidden = YES;
            noBankCardView.hidden = YES;
            bankNameLabel.text = [responseObject[0] objectForKey:@"bankName"];
            branchLabel.text = [[responseObject[0] objectForKey:@"subBankName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cardNumLabel.text = [responseObject[0] objectForKey:@"cardCode"];
            oneLimitLabel.text = [responseObject[0] objectForKey:@"limitAmount"];
            dayLimitLabel.text = [responseObject[0] objectForKey:@"dailyLimit"];
            bankImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[responseObject[0] objectForKey:@"imgUrl"]]]];
            confirmButton.hidden = NO;
            editView.hidden = NO;
        }
        else
        {
            bankCardView.hidden = YES;
            noBankCardView.hidden = NO;
            addBankCardButton.hidden = NO;
            confirmButton.hidden = YES;
            editView.hidden = YES;
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
        NSLog(@"%@",responseObject);
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
            [hud hide:YES];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还未进行实名验证，请先进行实名验证" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                RealNameViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RealNameViewController"];
                [[self navigationController]pushViewController:vc animated:YES];
            }];
            [alertController addAction:cancelAction];
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

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString *str = oneLimitLabel.text;
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (str.doubleValue < editTextField.text.doubleValue)
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"超过单笔限额";
        [hud hide:YES afterDelay:1.5f];
    }
    else
    {
        NSURL*url = [NSURL URLWithString:[BASEURL stringByAppendingString:@"account/BaoFooRenzhengSDKCharge"]];
        NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        NSString *para = [NSString stringWithFormat:@"txn_amt=%f",(editTextField.text.doubleValue * 100)];
        //添加请求数据
        [request setHTTPBody:[para dataUsingEncoding:NSUTF8StringEncoding]];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([[dict objectForKey:@"retCode"] isEqualToString:@"0000"]) {
                    [hud hide:YES];
                    BaoFooPayController*web = [[BaoFooPayController alloc] init];
                    web.PAY_TOKEN = [dict objectForKey:@"tradeNo"];
                    web.delegate = self;
                    web.PAY_BUSINESS = @"true";
                    [self presentViewController:web animated:YES completion:nil];
                }
                else
                {
                    NSString *errorMsg = [dict objectForKey:@"retMsg"];
                    if (!errorMsg) {
                        errorMsg = @"创建订单号失败";
                    }
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = errorMsg;
                    [hud hide:YES afterDelay:1.5f];
                }
            });
        }];

    }
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [editTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [editTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
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

#pragma mark - BaofooDelegate
-(void)callBack:(NSString*)params
{
    NSString *str = [params substringToIndex:1];
    if ([str isEqualToString:@"1"])
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

@end
