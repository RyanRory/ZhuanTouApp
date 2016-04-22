//
//  AddBankCardViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/30.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "AddBankCardViewController.h"

@interface AddBankCardViewController ()

@end

@implementation AddBankCardViewController

@synthesize confirmButton, bankButton, cityButton, provinceButton;
@synthesize nameLabel, bankTextField, accountNumTextField, phoneNumTextField;
@synthesize bankLabel, provinceLabel, cityLabel;

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
    
    [bankButton addTarget:self action:@selector(showChooseDetail:) forControlEvents:UIControlEventTouchUpInside];
    [provinceButton addTarget:self action:@selector(showChooseDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cityButton addTarget:self action:@selector(showChooseDetail:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    nameLabel.text = fullName;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [view removeFromSuperview];
    [bgView removeFromSuperview];
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

- (void)setFullName:(NSString*)str
{
    fullName = str;
}

- (void)showChooseDetail:(UIButton*)sender
{
    [bankTextField resignFirstResponder];
    [accountNumTextField resignFirstResponder];
    [phoneNumTextField resignFirstResponder];
    
    if (sender == bankButton)
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
    else if (sender == provinceButton)
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

- (void)confirm:(id)sender
{
    [bankTextField resignFirstResponder];
    [accountNumTextField resignFirstResponder];
    [phoneNumTextField resignFirstResponder];
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *cardReg = @"^[0-9]{16,30}$";
    NSPredicate *regextestId = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardReg];
    
    if(![regextestId evaluateWithObject: accountNumTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请检查您的银行卡号码是否正确";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [accountNumTextField becomeFirstResponder];
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
    else
    {
        [confirmButton setUserInteractionEnabled:NO];
        [confirmButton setAlpha:0.6f];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/addBankCardInAPP"]];
        NSDictionary *paramter = @{@"BankCode":[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankCodeList" ofType:@"plist"]] objectForKey:bankLabel.text],
                                   //@"SubBankName":[bankTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                   @"SubBankName":bankTextField.text,
                                   @"CardCode":accountNumTextField.text,
                                   @"Province":provinceLabel.text,
                                   @"City":cityLabel.text,
                                   @"BindedMobile":phoneNumTextField.text};
        [manager POST:URL parameters:paramter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"绑定成功";
                [hud hide:YES afterDelay:1.0f];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
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

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)textFiledReturnEditing:(id)sender {

    [(UITextField*)sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [bankTextField resignFirstResponder];
    [accountNumTextField resignFirstResponder];
    [phoneNumTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((bankTextField.text.length > 0) && (accountNumTextField.text.length > 0) && (phoneNumTextField.text.length > 0) && (![bankLabel.text isEqualToString:@"请选择"]) && (![provinceLabel.text isEqualToString:@"请选择"]) && (![cityLabel.text isEqualToString:@"请选择"]))
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
