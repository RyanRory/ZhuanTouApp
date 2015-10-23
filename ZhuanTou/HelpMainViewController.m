//
//  HelpMainViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/23.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "HelpMainViewController.h"

@interface HelpMainViewController ()

@end

@implementation HelpMainViewController

@synthesize tView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    tView.showsVerticalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 3;
    else
        return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier0 = @"HelpCommonTableViewCell";
    static NSString *identifier1 = @"HelpDescriptionTableViewCell";
    
    if ((indexPath.section == 1) && (indexPath.row == 1))
    {
        HelpDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell)
        {
            cell = [[HelpDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        cell.titleLabel.text = @"客服热线";
        cell.descriptionLabel.text = @"400-698-9861";
        
        return cell;
    }
    else if ((indexPath.section == 2) && (indexPath.row == 1))
    {
        HelpDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell)
        {
            cell = [[HelpDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        cell.titleLabel.text = @"版本号";
        cell.descriptionLabel.text = @"1.0.0";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        HelpCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier0];
        if (!cell)
        {
            cell = [[HelpCommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier0];
        }
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"常见问题";
            }
            else if (indexPath.row == 1)
            {
                cell.titleLabel.text = @"意见反馈";
            }
            else
            {
                cell.titleLabel.text = @"去评价";
            }
        }
        else if (indexPath.section == 1)
        {
            cell.titleLabel.text = @"QQ联系";
        }
        else
        {
            cell.titleLabel.text = @"关于专投网";
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {

        }
        else if (indexPath.row == 1)
        {
            FeedbackViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [[self navigationController]pushViewController:vc animated:YES];
        }
        else
        {

        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {

        }
        else
        {

        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            AboutViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"AboutViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [[self navigationController]pushViewController:vc animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
