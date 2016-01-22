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
@synthesize deSlideButton;
@synthesize bigPortraitImageView, mobileLabel, nickNameLabel, realNameButton, realNameLabel, bankCardButton, bankCardNumLabel, loginPswdButton, tradePswdButton, tradePswdLabel, gesturePswdButton, moreButton, signOutButton;
@synthesize navigationView, navigationLeftButton, headImageView, usernameLabel, navigationRightButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [[self navigationController]setNavigationBarHidden:YES animated:NO];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    tView.layer.masksToBounds = NO;
    tView.layer.shadowColor = [UIColor blackColor].CGColor;
    tView.layer.shadowOffset = CGSizeMake(-4, 0);
    tView.layer.shadowOpacity = 0.5;
    
    deSlideButton.hidden = YES;
    [deSlideButton addTarget:self action:@selector(Deslide) forControlEvents:UIControlEventTouchUpInside];
    [navigationLeftButton addTarget:self action:@selector(Slide:) forControlEvents:UIControlEventTouchUpInside];
    [navigationRightButton addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [signOutButton addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
    [realNameButton addTarget:self action:@selector(toRealName:) forControlEvents:UIControlEventTouchUpInside];
    [bankCardButton addTarget:self action:@selector(toBankCard:) forControlEvents:UIControlEventTouchUpInside];
    [loginPswdButton addTarget:self action:@selector(toLoginPswd:) forControlEvents:UIControlEventTouchUpInside];
    [tradePswdButton addTarget:self action:@selector(toTradePswd:) forControlEvents:UIControlEventTouchUpInside];
    [gesturePswdButton addTarget:self action:@selector(toGesture:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton addTarget:self action:@selector(toMore:) forControlEvents:UIControlEventTouchUpInside];
    
    navigationView.hidden = YES;
    
//    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [tView addGestureRecognizer:pan];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    isSlide = false;
    
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    [self Deslide];
}

-(void)pan:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if(sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [sender translationInView:self.view];
        if (((translation.x > 0) && (tView.frame.origin.x < SCREEN_WIDTH-75)) || ((translation.x < 0) && (tView.frame.origin.x > frame.origin.x)))
        {
            if (tView.center.x + translation.x < frame.origin.x)
            {
                tView.center = CGPointMake(frame.origin.x,initalCenter.y);
                navigationView.center = CGPointMake(frame.origin.x, navigationCenter.y);
            }
            else
            {
                tView.center = CGPointMake(initalCenter.x + translation.x,initalCenter.y);
                navigationView.center = CGPointMake(navigationCenter.x + translation.x, navigationCenter.y);
            }
        }
    }
    else
    {
        CGPoint translation = [sender translationInView:self.view];
        if (translation.x > 0)
        {
            if (tView.frame.origin.x > (SCREEN_WIDTH-75)/3)
            {
                [self Slide];
            }
            else
            {
                [self Deslide];
            }
        }
        else
        {
            if (tView.frame.origin.x < (SCREEN_WIDTH-75)/3*2)
            {
                [self Deslide];
            }
            else
            {
                [self Slide];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefault boolForKey:ISLOGIN];
    if (!flag)
    {
        UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
        [[self tabBarController] presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        navigationView.hidden = NO;
        [self setupData];
        headImageView.image = [UIImage imageNamed:@"defaultHeadPortrait.png"];
        usernameLabel.text = [userDefault objectForKey:NICKNAME];

    }
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    if (SCREEN_WIDTH > 400)
    {
        frame = CGRectMake(0, 0, tView.frame.size.width, tView.frame.size.height);
    }
    else
    {
        frame = CGRectMake(-4, 0, tView.frame.size.width, tView.frame.size.height);
    }
    initalCenter = tView.center;
    navigationCenter = navigationView.center;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:ISLOGIN])
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)becomeForeground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tView.mj_header beginRefreshing];
    });
}

- (void)Slide:(UIButton*)sender
{
    if (tView.frame.origin.x <= 0)
    {
        [self Slide];
    }
    else
    {
        [self Deslide];
    }
}

- (void)Slide
{
    isSlide = true;
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:0.2f];
    [navigationView setFrame:CGRectMake(SCREEN_WIDTH-75, 20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    [tView setFrame:CGRectMake(SCREEN_WIDTH-75, 0, tView.frame.size.width, tView.frame.size.height)];
    [UIView commitAnimations];
    initalCenter = tView.center;
    navigationCenter = navigationView.center;
    [tView addGestureRecognizer:tap];
}

- (void)Deslide
{
    isSlide = false;
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:0.2f];
    [navigationView setFrame:CGRectMake(frame.origin.x, 20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    [tView setFrame:frame];
    [UIView commitAnimations];
    initalCenter = tView.center;
    navigationCenter = navigationView.center;
    [tView removeGestureRecognizer:tap];
}

- (void)setupData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:ISTRADEPSWDSET])
    {
        tradePswdLabel.text = @"修改";
    }
    else
    {
        tradePswdLabel.text = @"未设置";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/getUserInfoInAPP"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            mobileLabel.text = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"mobilePhone"]];
            if ([NSString stringWithFormat:@"%@", [responseObject objectForKey:@"isBankCardBinded"]].boolValue)
            {
                bankCardNumLabel.text = @"已绑定";
            }
            else
            {
                bankCardNumLabel.text = @"未绑定";
            }
            [userDefault setObject:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"userName"]] forKey:NICKNAME];
            usernameLabel.text = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"userName"]];
            nickNameLabel.text = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"userName"]];
            data = [NSMutableDictionary dictionaryWithDictionary:responseObject];
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
    
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    NSString *URL1 = [BASEURL stringByAppendingString:@"api/account/IsIdentified"];
    [manager1 POST:URL1 parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            realNameLabel.text = @"已认证";
        }
        else
        {
            realNameLabel.text = @"未认证";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];


}

#pragma ButtonActions

- (void)toCharge:(id)sender
{
    if (!isSlide)
    {
        ChargeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ChargeViewController"];
        vc.isFromUserCenter = YES;
        [[self navigationController]pushViewController:vc animated:YES];
    }
    else
    {
        [self Deslide];
    }
}

- (void)toDraw:(id)sender
{
    if (!isSlide)
    {
        DrawViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DrawViewController"];
        vc.isFromUserCenter = YES;
        [[self navigationController]pushViewController:vc animated:YES];
    }
    else
    {
        [self Deslide];
    }
}

- (void)toProfit:(id)sender
{
    if (!isSlide)
    {
        ProfitViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProfitViewController"];
        [[self navigationController]pushViewController:vc animated:YES];
    }
    else
    {
        [self Deslide];
    }
}

- (void)toAllIcome:(id)sender
{
    if (!isSlide)
    {
        AllIncomeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"AllIncomeViewController"];
        [[self navigationController]pushViewController:vc animated:YES];
    }
    else
    {
        [self Deslide];
    }
}

- (void)toYesterdayIncome:(id)sender
{
    if (!isSlide)
    {
        YesterdayIncomeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"YesterdayIncomeViewController"];
        [[self navigationController]pushViewController:vc animated:YES];
    }
    else
    {
        [self Deslide];
    }
}

- (void)toDetail:(id)sender
{
    DetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toBankCard:(id)sender
{
    [self Deslide];
    BankCardViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"BankCardViewController"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)toMore:(id)sender
{
    [self Deslide];
    HelpMainViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"HelpMainViewController"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)toRealName:(id)sender
{
    if ([realNameLabel.text isEqualToString:@"未认证"])
    {
        [self Deslide];
        RealNameViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RealNameViewController"];
        vc.isFromUserCenter = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"您已认证，不可更改";
        [hud hide:YES afterDelay:1.5f];
    }
}

- (void)toTradePswd:(id)sender
{
    [self Deslide];
    if ([tradePswdLabel.text isEqualToString:@"未设置"])
    {
        SetTradePswdViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetTradePswdViewController"];
        vc.isFromUserCenter = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
    else
    {
        ResetTradePswdViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ResetTradePswdViewController"];
        vc.isFromUserCenter = YES;
        [vc setStyle:RESETTRADEPSWD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
}

- (void)toLoginPswd:(id)sender
{
    [self Deslide];
    ResetTradePswdViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ResetTradePswdViewController"];
    vc.isFromUserCenter = YES;
    [vc setStyle:RESETLOGINPSWD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)toGesture:(id)sender
{
    [self Deslide];
    SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
    setpass.isFromUserCenter = YES;
    setpass.string = @"修改密码";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:setpass animated:YES];
    });
}

- (void)signOut:(id)sender
{
    [self Deslide];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否确认安全退出当前账户？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self.navigationController.view addSubview:hud];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:@"Account/SignOut"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
            
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"登出成功";
            [hud hide:YES afterDelay:1.0f];
            self.navigationItem.leftBarButtonItem = nil;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:ISLOGIN];
            [userDefault removeObjectForKey:PASSWORD];
            [userDefault removeObjectForKey:ISTRADEPSWDSET];
            [userDefault synchronize];
            [data removeAllObjects];
            [tView reloadData];
            navigationView.hidden = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                [[self tabBarController] presentViewController:nav animated:YES completion:nil];
                
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"登出成功";
            [hud hide:YES afterDelay:1.0f];
            self.navigationItem.leftBarButtonItem = nil;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:ISLOGIN];
            [userDefault removeObjectForKey:PASSWORD];
            [userDefault synchronize];
            [data removeAllObjects];
            [tView reloadData];
            navigationView.hidden = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                [[self tabBarController] presentViewController:nav animated:YES completion:nil];
                
            });
        }];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
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
        if (SCREEN_WIDTH < 350)
        {
            return 305;
        }
        else if (SCREEN_WIDTH > 400)
        {
            return 355;
        }
        else
        {
            return 325;
        }
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
        [cell.toAllButon addTarget:self action:@selector(toAllIcome:) forControlEvents:UIControlEventTouchUpInside];
        [cell.toYesterdayButton addTarget:self action:@selector(toYesterdayIncome:) forControlEvents:UIControlEventTouchUpInside];
        if (data.count == 0)
        {
            cell.propertyLabel.text = @"0.00";
            cell.balanceLabel.text = @"可用余额(元):0.00";
            cell.allProfitLabel.text = @"0.00";
            cell.yesterdayProfitLabel.text = @"0.00";
        }
        else
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.propertyLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@", [data objectForKey:@"totalAsset"]].doubleValue]];
            cell.balanceLabel.text = [NSString stringWithFormat:@"可用余额(元):%@", [formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@", [data objectForKey:@"fundsAvailable"]].doubleValue]]];
            cell.allProfitLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@", [data objectForKey:@"totalReturnAmount"]].doubleValue]];
            cell.yesterdayProfitLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@", [data objectForKey:@"ystGain"]].doubleValue]];
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
                    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@张", [data objectForKey:@"activeCouponAmount"]];
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
            InvitationViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"InvitationViewController"];
            [[self navigationController]pushViewController:vc animated:YES];
        }
    }
}


@end
