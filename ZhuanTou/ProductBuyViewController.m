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
@synthesize bgView, amountTextField, tradePswdTextField, restLabel, contentView;
@synthesize noBonusLabel, checkboxButton, agreementButton, confirmButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
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
    self.title = @"购买固定收益产品";
    bgView.backgroundColor = ZTLIGHTRED;
    headBgView.backgroundColor = ZTLIGHTRED;
    confirmButton.backgroundColor = ZTLIGHTRED;
    chargeButton.tintColor = ZTLIGHTRED;
}

- (void)setupZonghe
{
    self.title = @"购买浮动收益产品";
    bgView.backgroundColor = ZTBLUE;
    headBgView.backgroundColor = ZTBLUE;
    confirmButton.backgroundColor = ZTBLUE;
    chargeButton.tintColor = ZTBLUE;
}

- (void)setupHuoqi
{
    self.title = @"购买专投宝产品";
    bgView.backgroundColor = ZTRED;
    headBgView.backgroundColor = ZTRED;
    confirmButton.backgroundColor = ZTRED;
    chargeButton.tintColor = ZTRED;
}

- (void)toAgreemet:(id)sender
{
    
}

- (void)confirm:(id)sender
{
    ProductBuyConfirmViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyConfirmViewController"];
    [vc setStyle:style];
    vc.title = self.title;
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toCharge:(id)sender
{
    
}

- (void)checkboxEnsure:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"checkIconActive.png"] forState:UIControlStateNormal];
        if ((amountTextField.text.length > 0) && (tradePswdTextField.text.length > 0))
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
    if (sender == amountTextField)
    {
        [tradePswdTextField becomeFirstResponder];
        [amountTextField resignFirstResponder];
    }
    else [tradePswdTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [amountTextField resignFirstResponder];
    [tradePswdTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((amountTextField.text.length > 0) && (tradePswdTextField.text.length > 0))
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
