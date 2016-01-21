//
//  InvitationViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/11.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "InvitationViewController.h"

@interface InvitationViewController ()

@end

@implementation InvitationViewController

@synthesize tView;
@synthesize invitationButton, myInvButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [invitationButton setUserInteractionEnabled:NO];
    [myInvButton setUserInteractionEnabled:YES];
    invitationButton.tintColor = ZTBLUE;
    myInvButton.tintColor = ZTGRAY;
    [invitationButton addTarget:self action:@selector(invitation:) forControlEvents:UIControlEventTouchUpInside];
    [myInvButton addTarget:self action:@selector(myInv:) forControlEvents:UIControlEventTouchUpInside];
    
    datas = [[NSMutableArray alloc]init];
    buffer = [[NSMutableArray alloc]init];
    
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData
{
    [buffer removeAllObjects];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/myReferrals"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        info = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        buffer = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"referees"]];
        datas = [NSMutableArray arrayWithArray:buffer];
        dataNum = (int)datas.count;
        [tView.mj_header endRefreshing];
        [tView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [tView.mj_header endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)invitation:(id)sender
{
    [invitationButton setUserInteractionEnabled:NO];
    [myInvButton setUserInteractionEnabled:YES];
    invitationButton.tintColor = ZTBLUE;
    myInvButton.tintColor = ZTGRAY;
    tView.scrollEnabled = NO;
    [tView reloadData];
}

- (void)myInv:(id)sender
{
    [invitationButton setUserInteractionEnabled:YES];
    [myInvButton setUserInteractionEnabled:NO];
    invitationButton.tintColor = ZTGRAY;
    myInvButton.tintColor = ZTBLUE;
    tView.scrollEnabled = YES;
    [tView.mj_header beginRefreshing];
}

#pragma TableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return 40;
    else
        return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return @"我推荐的好友";
    else
        return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (invitationButton.userInteractionEnabled)
    {
        return dataNum+1;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (invitationButton.userInteractionEnabled)
    {
        return 134;
    }
    else
    {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (invitationButton.userInteractionEnabled)
    {
        return 1;
    }
    else
    {
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"InvitationTableViewCell";
    static NSString *identifier2 = @"MyInvTableViewCell";
    if (invitationButton.userInteractionEnabled)
    {
        MyInvTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell)
        {
            cell = [[MyInvTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        if (indexPath.section == 0)
        {
            cell.label1.text = [NSString stringWithFormat:@"累计奖励现金：%d元",[NSString stringWithFormat:@"%@",[info objectForKey:@"referralCashAmount"]].intValue];
            cell.label2.text = [NSString stringWithFormat:@"累计奖励加息券：%d张",[NSString stringWithFormat:@"%@",[info objectForKey:@"referralVoucherCount"]].intValue];
            cell.label3.text = [NSString stringWithFormat:@"累计推荐好友人数:%d人",[NSString stringWithFormat:@"%@",[info objectForKey:@"refereeCount"]].intValue];
        }
        else
        {
            id data = [datas objectAtIndex:indexPath.section-1];
            cell.label1.text = [NSString stringWithFormat:@"好友ID：%@", [data objectForKey:@"username"]];
            cell.label2.text = [NSString stringWithFormat:@"奖励加息券：%d张", [NSString stringWithFormat:@"%@",[data objectForKey:@"referralVoucherCount"]].intValue];
            cell.label3.text = [NSString stringWithFormat:@"奖励现金：%d元", [NSString stringWithFormat:@"%@",[data objectForKey:@"referralCashAmount"]].intValue];
        }
        
        return cell;
    }
    else
    {
        InvitationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell)
        {
            cell = [[InvitationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        switch (indexPath.row) {
            case 0:
                cell.image.image = [UIImage imageNamed:@"wechat.png"];
                cell.label.text = @"微信好友";
                break;
                
            case 1:
                cell.image.image = [UIImage imageNamed:@"moments.png"];
                cell.label.text = @"微信朋友圈";
                break;
                
            case 2:
                cell.image.image = [UIImage imageNamed:@"weibo.png"];
                cell.label.text = @"新浪微博";
                break;
                
            case 3:
                cell.image.image = [UIImage imageNamed:@"qq.png"];
                cell.label.text = @"QQ好友";
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
