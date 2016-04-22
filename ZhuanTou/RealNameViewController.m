//
//  RealNameViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "RealNameViewController.h"

@interface RealNameViewController ()

@end

@implementation RealNameViewController

@synthesize realNameTextField, idNumTextField, confirmButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    confirmButton.layer.cornerRadius = 3;
    
    idNumTextField.inputView = ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        [numberPad.leftFunctionButton setTitle:@"X" forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [realNameTextField resignFirstResponder];
    [idNumTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:hud];
    NSString *idReg = @"^[0-9]{17}[0-9X]$";
    NSPredicate *regextestId = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idReg];
    
    NSArray *weights = [[NSArray alloc]initWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSArray *partityBits = [[NSArray alloc]initWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil];
    int power = 0;
    const char *chars = [idNumTextField.text cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i=0; i<17; i++)
    {
        power += ((int)chars[i]-48) * ((NSString*)weights[i]).intValue;
    }

    if((![regextestId evaluateWithObject: idNumTextField.text]) || !([(NSString*)partityBits[power%11] isEqualToString:[NSString stringWithCString:&chars[17] encoding:NSUTF8StringEncoding]]))
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请检查您的身份证号码是否正确";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [idNumTextField becomeFirstResponder];
        });
    }
    else
    {
        [confirmButton setUserInteractionEnabled:NO];
        [confirmButton setAlpha:0.6f];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/setIdCard/%@/%@", idNumTextField.text, [realNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
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
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                if ([userDefault boolForKey:ISTRADEPSWDSET])
                {
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"认证成功";
                    [hud hide:YES afterDelay:1.0f];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });

                }
                else
                {
                    [hud hide:YES];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"实名认证成功，是否设置交易密码？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *gotoSet = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        SetTradePswdViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetTradePswdViewController"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertController addAction:gotoSet];
                    [alertController addAction:cancel];
                    [self presentViewController:alertController animated:YES completion:nil];
                }

            }
            
            [confirmButton setUserInteractionEnabled:YES];
            [confirmButton setAlpha:1.0f];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
            
            [confirmButton setUserInteractionEnabled:YES];
            [confirmButton setAlpha:1.0f];
        }];

    }
}

#pragma mark - APNumberPadDelegate

- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    [textInput insertText:@"X"];
}

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == realNameTextField)
    {
        [idNumTextField becomeFirstResponder];
        [realNameTextField resignFirstResponder];
    }
    else [idNumTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [realNameTextField resignFirstResponder];
    [idNumTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((realNameTextField.text.length > 0) && (idNumTextField.text.length > 0))
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
