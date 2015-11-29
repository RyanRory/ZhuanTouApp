//
//  BonusViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/25.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "BonusViewController.h"

@interface BonusViewController ()

@end

@implementation BonusViewController

@synthesize tView;
@synthesize cannotUseButton, canUseButton, noBonusLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [canUseButton setUserInteractionEnabled:NO];
    [cannotUseButton setUserInteractionEnabled:YES];
    canUseButton.tintColor = ZTBLUE;
    cannotUseButton.tintColor = ZTGRAY;
    [canUseButton addTarget:self action:@selector(canUse:) forControlEvents:UIControlEventTouchUpInside];
    [cannotUseButton addTarget:self action:@selector(cannotUse:) forControlEvents:UIControlEventTouchUpInside];
    noBonusLabel.hidden = YES;
    
    tView.showsHorizontalScrollIndicator = NO;
    tView.showsVerticalScrollIndicator = NO;
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           [self setupData];
    }];
    [tView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)becomeForeground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tView.mj_header beginRefreshing];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)canUse:(id)sender
{
    [canUseButton setUserInteractionEnabled:NO];
    [cannotUseButton setUserInteractionEnabled:YES];
    canUseButton.tintColor = ZTBLUE;
    cannotUseButton.tintColor = ZTGRAY;
    [tView.mj_header beginRefreshing];
}

- (void)cannotUse:(id)sender
{
    [canUseButton setUserInteractionEnabled:YES];
    [cannotUseButton setUserInteractionEnabled:NO];
    canUseButton.tintColor = ZTGRAY;
    cannotUseButton.tintColor = ZTBLUE;
    [tView.mj_header beginRefreshing];
}

- (void)setupData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/getCouponsInApp"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        canDatas = [[NSMutableArray alloc]init];
        cannotDatas = [[NSMutableArray alloc]init];
        for (int i=0; i<responseObject.count; i++)
        {
            if ([[NSString stringWithFormat:@"%@",[responseObject[i] objectForKey:@"status"]] isEqualToString:@"可使用"])
            {
                [canDatas addObject:responseObject[i]];
            }
            else
            {
                [cannotDatas addObject:responseObject[i]];
            }
        }
        if (cannotUseButton.userInteractionEnabled)
        {
            datas = [NSMutableArray arrayWithArray:canDatas];
            if (datas.count > 0)
            {
                noBonusLabel.hidden = YES;
            }
            else
            {
                noBonusLabel.hidden = NO;
                noBonusLabel.text = @"暂无可使用红包";
            }
        }
        else
        {
            datas = [NSMutableArray arrayWithArray:cannotDatas];
            if (datas.count > 0)
            {
                noBonusLabel.hidden = YES;
            }
            else
            {
                noBonusLabel.hidden = NO;
                noBonusLabel.text = @"暂无已失效红包";
            }
        }
        bonusNum = (int)datas.count;
        [tView.mj_header endRefreshing];
        [tView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [tView.mj_header endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"当前用户未被授权执行当前操作";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                [[self tabBarController] presentViewController:nav animated:YES completion:nil];
            });
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
        [hud hide:YES afterDelay:1.5f];
    }];

}

- (void)toProduct:(id)sender
{
    ZTTabBarViewController *tabVC = (ZTTabBarViewController*)[self tabBarController];
    [tabVC setSelectedIndex:1];
    [[self navigationController]popViewControllerAnimated:YES];
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
    return 127;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bonusNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [datas objectAtIndex:indexPath.row];
    static NSString *identifier = @"BonusTableViewCell";
    BonusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[BonusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.toProductButton addTarget:self action:@selector(toProduct:) forControlEvents:UIControlEventTouchUpInside];
    cell.amountLabel.text = [data objectForKey:@"money"];
    cell.ddlLabel.text = [NSString stringWithFormat:@"%@过期",[data objectForKey:@"expireTime"]];
    cell.ruleLabel.text = [NSString stringWithFormat:@"使用规则：投资满%@元可抵%@元现金",[data objectForKey:@"thresholdValue"],[data objectForKey:@"money"]];
    if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]] isEqualToString:@"可使用"])
    {
        cell.bgView.backgroundColor = ZTBLUE;
        cell.statusLabel.text = @"选购产品";
        cell.statusLabel.textColor = ZTBLUE;
        cell.ddlLabel.textColor = ZTBLUE;
        [cell.toProductButton setUserInteractionEnabled:YES];
    }
    else
    {
        cell.bgView.backgroundColor = ZTGRAY;
        cell.statusLabel.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        cell.statusLabel.textColor = ZTGRAY;
        cell.ddlLabel.textColor = ZTGRAY;
        [cell.toProductButton setUserInteractionEnabled:NO];
    }
    
    return cell;
}



@end
