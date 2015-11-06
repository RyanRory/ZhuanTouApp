//
//  AutoViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/5.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "AutoViewController.h"

@interface AutoViewController ()

@end

@implementation AutoViewController

@synthesize wenjianAllSwitch, wenjianSwitch, wenjianAllView, wenjianEditView, wenjianTextField;
@synthesize zongheAllSwitch, zongheAllView, zongheEditView, zongheSwitch, zongheTextField;
@synthesize confirmButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    confirmButton.layer.cornerRadius = 3;
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    wenjianAllView.hidden = YES;
    wenjianEditView.hidden = YES;
    wenjianSwitch.on = NO;
    wenjianAllSwitch.on = NO;
    wenjianSwitch.onColor = ZTLIGHTRED;
    wenjianAllSwitch.onColor = ZTLIGHTRED;
    
    zongheAllView.hidden = YES;
    zongheEditView.hidden = YES;
    zongheSwitch.on = NO;
    zongheAllSwitch.on = NO;
    zongheSwitch.onColor = ZTBLUE;
    zongheAllSwitch.onColor = ZTBLUE;
    
    [wenjianSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [wenjianAllSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [zongheSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [zongheAllSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData
{
    NSLog(@"%d",zongheAllSwitch.on);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/queue/myq4m"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if (((NSString*)[responseObject objectForKey:@"fixedIntEnabled"]).boolValue)
        {
            wenjianSwitch.on = YES;
            wenjianAllView.hidden = NO;
            if (((NSString*)[responseObject objectForKey:@"fixedIntInvestAll"]).boolValue)
            {
                wenjianAllSwitch.on = YES;
            }
            else
            {
                wenjianAllSwitch.on = NO;
                wenjianEditView.hidden = NO;
                wenjianTextField.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"fixedIntMaxAmount"]];
            }
        }
        else
        {
            wenjianSwitch.on = NO;
        }
        if (((NSString*)[responseObject objectForKey:@"floatingPlEnabled"]).boolValue)
        {
            zongheSwitch.on = YES;
            zongheAllView.hidden = NO;
            if (((NSString*)[responseObject objectForKey:@"floatingPlInvestAll"]).boolValue)
            {
                zongheAllSwitch.on = YES;
            }
            else
            {
                zongheAllSwitch.on = NO;
                zongheEditView.hidden = NO;
                zongheTextField.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"floatingPlMaxAmount"]];
            }
        }
        else
        {
            zongheSwitch.on = NO;
        }
        [hud hide:YES];
        
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

- (void)valueChanged:(SimpleSwitch*)sender
{
    if (sender == wenjianSwitch)
    {
        if (sender.on)
        {
            wenjianAllView.hidden = NO;
        }
        else
        {
            wenjianAllView.hidden = YES;
            wenjianAllSwitch.on = YES;
        }
    }
    else if (sender == wenjianAllSwitch)
    {
        wenjianEditView.hidden = sender.on;
    }
    else if (sender == zongheSwitch)
    {
        if (sender.on)
        {
            zongheAllView.hidden = NO;
        }
        else
        {
            zongheAllView.hidden = YES;
            zongheAllSwitch.on = YES;
        }
    }
    else
    {
        zongheEditView.hidden = sender.on;
    }
    if (!((wenjianSwitch.on && (!wenjianAllSwitch.on) && (wenjianTextField.text.length == 0)) || (zongheSwitch.on && (!zongheAllSwitch.on) && (zongheTextField.text.length == 0))))
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

- (void)confirm:(id)sender
{
    flag = false;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if (wenjianSwitch.on)
    {
        if (wenjianAllSwitch.on)
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *URL = [BASEURL stringByAppendingString:@"api/queue/enable/0"];
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
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    NSString *URL = [BASEURL stringByAppendingString:@"api/queue/changeQAmount/0/true"];
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
                            if (flag)
                            {
                                hud.mode = MBProgressHUDModeCustomView;
                                hud.labelText = @"设置成功";
                                [hud hide:YES afterDelay:1.5f];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [[self navigationController]popViewControllerAnimated:YES];
                                });
                            }
                            else
                            {
                                flag = true;
                            }
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"当前网络状况不佳，请重试";
                        [hud hide:YES afterDelay:1.5f];
                    }];

                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"当前网络状况不佳，请重试";
                [hud hide:YES afterDelay:1.5f];
            }];
        }
        else
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *URL = [BASEURL stringByAppendingString:@"api/queue/enable/0"];
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
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/queue/changeQAmount/0/false/%@",wenjianTextField.text]];
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
                            if (flag)
                            {
                                hud.mode = MBProgressHUDModeCustomView;
                                hud.labelText = @"设置成功";
                                [hud hide:YES afterDelay:1.5f];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [[self navigationController]popViewControllerAnimated:YES];
                                });
                            }
                            else
                            {
                                flag = true;
                            }
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"当前网络状况不佳，请重试";
                        [hud hide:YES afterDelay:1.5f];
                    }];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"当前网络状况不佳，请重试";
                [hud hide:YES afterDelay:1.5f];
            }];

        }
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:@"api/queue/disable/0"];
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
                if (flag)
                {
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"设置成功";
                    [hud hide:YES afterDelay:1.5f];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[self navigationController]popViewControllerAnimated:YES];
                    });
                }
                else
                {
                    flag = true;
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
        }];
    }
    
    if (zongheSwitch.on)
    {
        if (zongheAllSwitch.on)
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *URL = [BASEURL stringByAppendingString:@"api/queue/enable/1"];
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
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    NSString *URL = [BASEURL stringByAppendingString:@"api/queue/changeQAmount/1/true"];
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
                            if (flag)
                            {
                                hud.mode = MBProgressHUDModeCustomView;
                                hud.labelText = @"设置成功";
                                [hud hide:YES afterDelay:1.5f];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [[self navigationController]popViewControllerAnimated:YES];
                                });
                            }
                            else
                            {
                                flag = true;
                            }
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"当前网络状况不佳，请重试";
                        [hud hide:YES afterDelay:1.5f];
                    }];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"当前网络状况不佳，请重试";
                [hud hide:YES afterDelay:1.5f];
            }];
        }
        else
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *URL = [BASEURL stringByAppendingString:@"api/queue/enable/1"];
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
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/queue/changeQAmount/1/false/%@",zongheTextField.text]];
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
                            if (flag)
                            {
                                hud.mode = MBProgressHUDModeCustomView;
                                hud.labelText = @"设置成功";
                                [hud hide:YES afterDelay:1.5f];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [[self navigationController]popViewControllerAnimated:YES];
                                });
                            }
                            else
                            {
                                flag = true;
                            }
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"当前网络状况不佳，请重试";
                        [hud hide:YES afterDelay:1.5f];
                    }];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"当前网络状况不佳，请重试";
                [hud hide:YES afterDelay:1.5f];
            }];
            
        }

    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:@"api/queue/disable/1"];
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
                if (flag)
                {
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"设置成功";
                    [hud hide:YES afterDelay:1.5f];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[self navigationController]popViewControllerAnimated:YES];
                    });
                }
                else
                {
                    flag = true;
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
        }];
    }
    
}

-(IBAction)textFiledReturnEditing:(id)sender {
    
    [(UITextField*)sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [wenjianTextField resignFirstResponder];
    [zongheTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if (!((wenjianSwitch.on && (!wenjianAllSwitch.on) && (wenjianTextField.text.length == 0)) || (zongheSwitch.on && (!zongheAllSwitch.on) && (zongheTextField.text.length == 0))))
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
