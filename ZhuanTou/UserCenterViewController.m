//
//  UserCenterViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/24.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "UserCenterViewController.h"

@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

@synthesize tView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.image = [UIImage imageNamed:@"defaultHeadPortrait.png"];
    imageView.layer.cornerRadius = 15;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 65, 30)];
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = [UIColor whiteColor];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    label.text = [userDefault objectForKey:NICKNAME];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [button addTarget:self action:@selector(Slide:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:imageView];
    [view addSubview:label];
    [view addSubview:button];
    UIBarButtonItem *slideButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = slideButton;
    
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefault boolForKey:ISLOGIN];
    if (!flag)
    {
        UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
        [[self tabBarController] presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        [self setupData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    CGRect rect=CGRectMake(0,0, 0.5, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:theImage];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)becomeForeground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tView.mj_header beginRefreshing];
    });
}

- (void)Slide:(id)sender
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES completion:^(){
        [self.navigationController.view setUserInteractionEnabled:NO];
        [self.navigationController.tabBarController.tabBar setUserInteractionEnabled:NO];
    }];
}

- (void)setupData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/getUserInfoInAPP"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            data = [NSDictionary dictionaryWithDictionary:responseObject];
            [tView reloadData];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:1.5f];
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorCode"]] isEqualToString:@"100003"])
            {
                hud.labelText = @"登录信息已过期，请重新登录";
                SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
                setpass.string = @"验证密码";
                [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
            }
            else
            {
                hud.labelText = [responseObject objectForKey:@"errorMessage"];
            }
        }
        if ([tView.mj_header isRefreshing])
        {
            [tView.mj_header endRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
        if ([tView.mj_header isRefreshing])
        {
            [tView.mj_header endRefreshing];
        }
    }];

}

- (void)toCharge:(id)sender
{
    ChargeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ChargeViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toDraw:(id)sender
{
    DrawViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DrawViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toProfit:(id)sender
{
    ProfitViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProfitViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

#pragma TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.001;
    }
    else
    {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 305;
    }
    else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"PropertyTableViewCell";
    static NSString *identifier2 = @"UserCenterTableViewCell";
    if (indexPath.section == 0)
    {
        PropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell)
        {
            cell = [[PropertyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        [cell.chargeButton addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
        [cell.drawButton addTarget:self action:@selector(toDraw:) forControlEvents:UIControlEventTouchUpInside];
        [cell.toProfitButton addTarget:self action:@selector(toProfit:) forControlEvents:UIControlEventTouchUpInside];
        if (data.count == 0)
        {
            cell.propertyLabel.text = @"0.00";
            cell.balanceLabel.text = @"可用余额(元):0.00";
        }
        else
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.propertyLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@", [data objectForKey:@"totalAsset"]].doubleValue]];
            cell.balanceLabel.text = [NSString stringWithFormat:@"可用余额(元):%@", [formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@", [data objectForKey:@"fundsAvailable"]].doubleValue]]];
        }
        
        return cell;
    }
    else
    {
        UserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell)
        {
            cell = [[UserCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"定期理财";
                if (data.count == 0)
                {
                    cell.descriptionLabel.text = @"0元";
                }
                else
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                    [formatter setPositiveFormat:@"###,##0.00"];
                    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@元", [formatter stringFromNumber:[data objectForKey:@"activeInvestAmount"]]];
                }
            }
            else
            {
                cell.titleLabel.text = @"活期理财";
                if (data.count == 0)
                {
                    cell.descriptionLabel.text = @"0元";
                }
                else
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                    [formatter setPositiveFormat:@"###,##0.00"];
                    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@元", [formatter stringFromNumber:[data objectForKey:@"ztbBalance"]]];
                }
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"我的优惠券";
                if (data.count == 0)
                {
                    cell.descriptionLabel.text = @"0张";
                }
                else
                {
                    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@张", [data objectForKey:@"acitveCouponsAmount"]];
                }
            }
            else
            {
                cell.titleLabel.text = @"邀请好友";
                cell.descriptionLabel.text = @"";
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            DingqiViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DingqiViewController"];
            [[self navigationController]pushViewController:vc animated:YES];
        }
        else
        {
            HuoqiViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"HuoqiViewController"];
            [[self navigationController]pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            BonusViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"BonusViewController"];
            [[self navigationController]pushViewController:vc animated:YES];
        }
        else
        {
            
        }
    }
}


@end
