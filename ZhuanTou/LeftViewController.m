//
//  LeftViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/21.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

@synthesize headImage, mobileLabel, nickNameLabel, tView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    ZTTabBarViewController *tabVC = (ZTTabBarViewController*)self.revealSideViewController.rootViewController;
    [tabVC.selectedViewController.view setUserInteractionEnabled:YES];
    [tabVC.tabBar setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData
{
    
}

#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LeftTableViewCell";
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[LeftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"实名认证";
            }
            else
            {
                cell.titleLabel.text = @"银 行 卡";
            }
            break;
        
        case 1:
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"登录密码";
            }
            else if (indexPath.row == 1)
            {
                cell.titleLabel.text = @"交易密码";
            }
            else
            {
                cell.titleLabel.text = @"手势密码";
            }
            break;
        
        case 2:
            cell.titleLabel.text = @"更多";
            cell.descriptionLabel.text = @"";
            break;
            
        case 3:
            cell.titleLabel.text = @"退出登录";
            cell.descriptionLabel.text = @"";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0)
            {
                
            }
            else
            {
                
            }
            break;
            
        case 1:
            if (indexPath.row == 0)
            {
                
            }
            else if (indexPath.row == 1)
            {
                
            }
            else
            {
                
            }
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        default:
            break;
    }
}


@end
