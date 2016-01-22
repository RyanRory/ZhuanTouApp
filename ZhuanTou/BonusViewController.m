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
@synthesize interestRateButton, bonusButton, StandingInterestRateButton, noBonusLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    UIBarButtonItem *ruleItem = [[UIBarButtonItem alloc]initWithTitle:@"使用说明" style:UIBarButtonItemStylePlain target:self action:@selector(toRule:)];
    self.navigationItem.rightBarButtonItem = ruleItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [bonusButton setUserInteractionEnabled:YES];
    [interestRateButton setUserInteractionEnabled:NO];
    [StandingInterestRateButton setUserInteractionEnabled:YES];
    bonusButton.tintColor = ZTGRAY;
    interestRateButton.tintColor = ZTBLUE;
    StandingInterestRateButton.tintColor = ZTGRAY;
    [bonusButton addTarget:self action:@selector(bonus:) forControlEvents:UIControlEventTouchUpInside];
    [interestRateButton addTarget:self action:@selector(interestRate:) forControlEvents:UIControlEventTouchUpInside];
    [StandingInterestRateButton addTarget:self action:@selector(standingInterestRate:) forControlEvents:UIControlEventTouchUpInside];
    noBonusLabel.hidden = YES;
    
    tView.showsHorizontalScrollIndicator = NO;
    tView.showsVerticalScrollIndicator = NO;
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           [self setupData];
    }];
    [tView.mj_header beginRefreshing];
}

- (void)toRule:(id)sender
{
    WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
    if (!bonusButton.userInteractionEnabled)
    {
        vc.title = @"红包使用说明";
        [vc setURL:[NSString stringWithFormat:@"%@Wap/WebView/Hb",BASEURL]];
    }
    else if (!interestRateButton.userInteractionEnabled)
    {
        vc.title = @"定期加息券使用说明";
        [vc setURL:[NSString stringWithFormat:@"%@Wap/WebView/Dqjxq",BASEURL]];
    }
    else
    {
        vc.title = @"募集期加息券使用说明";
        [vc setURL:[NSString stringWithFormat:@"%@Wap/WebView/Mjqjxq",BASEURL]];
    }
    
    [[self navigationController]pushViewController:vc animated:YES];
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)bonus:(id)sender
{
    [bonusButton setUserInteractionEnabled:NO];
    [interestRateButton setUserInteractionEnabled:YES];
    [StandingInterestRateButton setUserInteractionEnabled:YES];
    bonusButton.tintColor = ZTBLUE;
    interestRateButton.tintColor = ZTGRAY;
    StandingInterestRateButton.tintColor = ZTGRAY;
    [tView.mj_header beginRefreshing];
}

- (void)interestRate:(id)sender
{
    [bonusButton setUserInteractionEnabled:YES];
    [interestRateButton setUserInteractionEnabled:NO];
    [StandingInterestRateButton setUserInteractionEnabled:YES];
    bonusButton.tintColor = ZTGRAY;
    interestRateButton.tintColor = ZTBLUE;
    StandingInterestRateButton.tintColor = ZTGRAY;
    [tView.mj_header beginRefreshing];
}

- (void)standingInterestRate:(id)sender
{
    [bonusButton setUserInteractionEnabled:YES];
    [interestRateButton setUserInteractionEnabled:YES];
    [StandingInterestRateButton setUserInteractionEnabled:NO];
    bonusButton.tintColor = ZTGRAY;
    interestRateButton.tintColor = ZTGRAY;
    StandingInterestRateButton.tintColor = ZTBLUE;
    [tView.mj_header beginRefreshing];
}

- (void)setupData
{
    if (!bonusButton.userInteractionEnabled)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:@"api/account/getCouponsInApp"];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
            NSLog(@"%@", responseObject);
            bonusDatas = [[NSMutableArray alloc]initWithArray:responseObject];
            datas = [NSMutableArray arrayWithArray:bonusDatas];
            if (datas.count > 0)
            {
                noBonusLabel.hidden = YES;
            }
            else
            {
                noBonusLabel.hidden = NO;
                noBonusLabel.text = @"暂无红包";
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
                hud.labelText = @"登录信息已过期，请重新登录";
                SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
                setpass.string = @"验证密码";
                [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
            }
            else
            {
                hud.labelText = @"当前网络状况不佳，请重试";
            }
            [hud hide:YES afterDelay:1.5f];
        }];
    }
    else if (!interestRateButton.userInteractionEnabled)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:@"api/voucher/myVouchers"];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
            NSLog(@"%@", responseObject);
            interestRateDatas = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < responseObject.count; i++)
            {
                id data = [responseObject objectAtIndex:i];
                if ([[data objectForKey:@"type"] isEqualToString:@"定期加息券"])
                {
                    [interestRateDatas addObject:data];
                }
            }
            datas = [NSMutableArray arrayWithArray:interestRateDatas];
            if (datas.count > 0)
            {
                noBonusLabel.hidden = YES;
            }
            else
            {
                noBonusLabel.hidden = NO;
                noBonusLabel.text = @"暂无加息券";
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
                hud.labelText = @"登录信息已过期，请重新登录";
                SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
                setpass.string = @"验证密码";
                [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
            }
            else
            {
                hud.labelText = @"当前网络状况不佳，请重试";
            }
            [hud hide:YES afterDelay:1.5f];
        }];
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:@"api/voucher/myVouchers"];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
            NSLog(@"%@", responseObject);
            standingInterestRateDatas = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < responseObject.count; i++)
            {
                id data = [responseObject objectAtIndex:i];
                if ([[data objectForKey:@"type"] isEqualToString:@"募集期加息券"])
                {
                    [standingInterestRateDatas addObject:data];
                }
            }
            datas = [NSMutableArray arrayWithArray:standingInterestRateDatas];
            if (datas.count > 0)
            {
                noBonusLabel.hidden = YES;
            }
            else
            {
                noBonusLabel.hidden = NO;
                noBonusLabel.text = @"暂无加息券";
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
                hud.labelText = @"登录信息已过期，请重新登录";
                SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
                setpass.string = @"验证密码";
                [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
            }
            else
            {
                hud.labelText = @"当前网络状况不佳，请重试";
            }
            [hud hide:YES afterDelay:1.5f];
        }];
    }
    

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
    if (!bonusButton.userInteractionEnabled)
    {
        NSString *identifier = @"BonusTableViewCell";
        BonusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[BonusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.toProductButton addTarget:self action:@selector(toProduct:) forControlEvents:UIControlEventTouchUpInside];
        cell.amountLabel.text = [data objectForKey:@"money"];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[data objectForKey:@"expireTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        cell.ddlLabel.text = [NSString stringWithFormat:@"有效期至:%ld-%ld-%ld",year,month,day];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        cell.ruleLabel.text = [NSString stringWithFormat:@"使用规则：单笔投资满%@元可用",[formatter stringFromNumber:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",[data objectForKey:@"thresholdValue"]].intValue]]];
        if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]] isEqualToString:@"可使用"])
        {
            cell.bgView.backgroundColor = ZTRED;
            cell.statusLabel.text = @"选购产品";
            cell.statusLabel.textColor = ZTRED;
            cell.ddlLabel.textColor = ZTRED;
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
    else
    {
        NSString *identifier = @"VoucherTableViewCell";
        VoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[VoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.toProductButton addTarget:self action:@selector(toProduct:) forControlEvents:UIControlEventTouchUpInside];
        cell.amountLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[data objectForKey:@"raiseRate"]].intValue];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[data objectForKey:@"expireTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        cell.ddlLabel.text = [NSString stringWithFormat:@"有效期至:%ld-%ld-%ld",year,month,day];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        cell.ruleLabel.text = [NSString stringWithFormat:@"使用规则：单笔投资最高%@元",[formatter stringFromNumber:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue]]];
        
        if (![NSString stringWithFormat:@"%@",[data objectForKey:@"used"]].boolValue)
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
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"expired"]].boolValue)
            {
                cell.statusLabel.text = @"已过期";
            }
            else
            {
                cell.statusLabel.text = @"已使用";
            }
            cell.statusLabel.textColor = ZTGRAY;
            cell.ddlLabel.textColor = ZTGRAY;
            [cell.toProductButton setUserInteractionEnabled:NO];
        }
        
        return cell;
    }
}



@end
