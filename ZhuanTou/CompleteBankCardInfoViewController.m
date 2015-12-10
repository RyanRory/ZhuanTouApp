//
//  CompleteBankCardInfoViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/7.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "CompleteBankCardInfoViewController.h"

@interface CompleteBankCardInfoViewController ()

@end

@implementation CompleteBankCardInfoViewController

@synthesize bankCardNoLabel, bankNameLabel, branchTextField, cityLabel, provinceLabel;
@synthesize confirmButton, chooseCityButton, chooseProvinceButton;

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
    
    provinceTemp = cityTemp = 0;
    
    [self.navigationController.view addSubview:bgView];
    [self.navigationController.view addSubview:view];
    
    provinceArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"provinceList" ofType:@"plist"]];
    
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showChooseDetail:(UIButton*)sender
{
    [branchTextField resignFirstResponder];
    
    if (sender == chooseProvinceButton)
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
    NSString *URL = [BASEURL stringByAppendingString:@"api/withdraw/applyWithdrawal4M"];
    NSDictionary *parameter = @{@"amount":self.amount,
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

- (IBAction)textFiledReturnEditing:(UITextField*)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
    [branchTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((![provinceLabel.text isEqualToString:@"请选择"]) && (![cityLabel.text isEqualToString:@"请选择"]) && (branchTextField.text.length > 0))
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
    if (buttonTag == 1)
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
    if (buttonTag == 1)
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
    if (buttonTag == 1)
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
    if (buttonTag == 1)
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
