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
    noBankCardView.hidden = NO;
    addBankCardButton.hidden = NO;
    editView.hidden = YES;
    confirmButton.hidden = YES;
    
    [self setupData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/withdraw/accountBankCards"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            [hud hide:YES];
            addBankCardButton.hidden = YES;
            noBankCardView.hidden = YES;
            editView.hidden = NO;
            confirmButton.hidden = NO;
            bankNameLabel.text = [responseObject objectForKey:@"bankName"];
            branchLabel.text = [responseObject objectForKey:@"subbranchBankName"];
            cardNumLabel.text = [responseObject objectForKey:@"cardCode"];
            oneLimitLabel.text = [responseObject objectForKey:@"limitAmount"];
            dayLimitLabel.text = [responseObject objectForKey:@"dailyLimit"];
        }
        else
        {
            [hud hide:YES];
            bankCardView.hidden = YES;
            noBankCardView.hidden = NO;
            addBankCardButton.hidden = NO;
            editView.hidden = YES;
            confirmButton.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSString *responseObject) {
        
        if (responseObject.boolValue)
        {
            AddBankCardViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"AddBankCardViewController"];
            [[self navigationController]pushViewController:vc animated:YES];
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
    NSLog(@"返回的参数是：%@",params);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:params message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
