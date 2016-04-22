//
//  DingqiViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/18.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "DingqiViewController.h"

@interface DingqiViewController ()

@end

@implementation DingqiViewController

@synthesize noneProductView, findProductButton, tView, ingButton, endedButton, standingButton, buttonTag;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    if (self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    findProductButton.layer.cornerRadius = 3;
    
    tView.showsHorizontalScrollIndicator = NO;
    tView.showsVerticalScrollIndicator = NO;
    tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [ingButton addTarget:self action:@selector(loadIngTableViewData:) forControlEvents:UIControlEventTouchUpInside];
    [standingButton addTarget:self action:@selector(loadStandingTableViewData:) forControlEvents:UIControlEventTouchUpInside];
    [endedButton addTarget:self action:@selector(loadEndedTableViewData:) forControlEvents:UIControlEventTouchUpInside];
    [findProductButton addTarget:self action:@selector(toProducts:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"TAG = %d", buttonTag);
    
    if (buttonTag == 0)
    {
        ingButton.tintColor = ZTBLUE;
        standingButton.tintColor = ZTGRAY;
        endedButton.tintColor = ZTGRAY;
        [ingButton setUserInteractionEnabled:NO];
    }
    else if (buttonTag == 1)
    {
        ingButton.tintColor = ZTGRAY;
        standingButton.tintColor = ZTGRAY;
        endedButton.tintColor = ZTBLUE;
        [endedButton setUserInteractionEnabled:NO];
    }
    else
    {
        ingButton.tintColor = ZTGRAY;
        standingButton.tintColor = ZTBLUE;
        endedButton.tintColor = ZTGRAY;
        [standingButton setUserInteractionEnabled:NO];
    }
    
    noneProductView.hidden = YES;
    findProductButton.hidden = YES;
    
    datas = [[NSMutableArray alloc]init];
    
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        switch (buttonTag) {
            case 0:
                [self loadIngTableViewData];
                break;
                
            case 1:
                [self loadEndedTableViewData];
                break;
            
            case 2:
                [self loadStandingTableViewData];
                break;
                
            default:
                break;
        }
    }];
    [tView.mj_header beginRefreshing];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePush:) name:@"RECEIVEPUSH" object:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)toProducts:(id)sender
{
    [[self tabBarController] setSelectedIndex:1];
}

- (void)loadIngTableViewData:(id)sender
{
    buttonTag = 0;
    [tView.mj_header beginRefreshing];
    standingButton.tintColor = ZTGRAY;
    ingButton.tintColor = ZTBLUE;
    endedButton.tintColor = ZTGRAY;
    [standingButton setUserInteractionEnabled:YES];
    [ingButton setUserInteractionEnabled:NO];
    [endedButton setUserInteractionEnabled:YES];
}

- (void)loadIngTableViewData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/myPurchases/99/3"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        datas = [self packgeData:responseObject];
        productsNum = (int)datas.count;
        if (productsNum == 0)
        {
            [noneProductView setHidden:NO];
            [findProductButton setHidden:NO];
            [tView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        else
        {
            [noneProductView setHidden:YES];
            [findProductButton setHidden:YES];
        }
        [tView reloadData];
        [tView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
        [tView.mj_header endRefreshing];
    }];
}

- (void)loadStandingTableViewData:(id)sender
{
    buttonTag = 2;
    [tView.mj_header beginRefreshing];
    standingButton.tintColor = ZTBLUE;
    ingButton.tintColor = ZTGRAY;
    endedButton.tintColor = ZTGRAY;
    [standingButton setUserInteractionEnabled:NO];
    [ingButton setUserInteractionEnabled:YES];
    [endedButton setUserInteractionEnabled:YES];
}

- (NSMutableArray*)packgeData:(NSArray*)firstLevelDatas
{
    NSMutableArray *tempdatas = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < firstLevelDatas.count; i++)
    {
        NSDictionary *firstLevelData = [[NSDictionary alloc]initWithDictionary:[firstLevelDatas objectAtIndex:i]];
        NSLog(@"%@",[firstLevelData  objectForKey:@"isFresh"]);
        if ([[firstLevelData  objectForKey:@"isFresh"] boolValue] == YES)
        {
            [tempdatas insertObject:firstLevelData atIndex:0];
        }
        else
        {
            if ([[firstLevelData objectForKey:@"aggregated"] boolValue] == NO)
            {
                [tempdatas addObject:firstLevelData];
            }
            else
            {
                NSMutableArray *secondLevelDatas = [[NSMutableArray alloc]initWithArray:[firstLevelData objectForKey:@"subInvests"]];
                for (int j = 0; j < secondLevelDatas.count; j++) {
                     NSDictionary *secondLevelData = [[NSDictionary alloc]initWithDictionary:[secondLevelDatas objectAtIndex:j]];
                    if ([[secondLevelData objectForKey:@"isFresh"] boolValue] == YES)
                    {
                        [tempdatas insertObject:secondLevelData atIndex:0];
                    }
                    else
                    {
                        [tempdatas addObject:secondLevelData];
                    }
                }

            }
        }
    }
    return tempdatas;
}

- (void)loadStandingTableViewData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/myPurchases/99/1"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        datas = [self packgeData:responseObject];
        productsNum = (int)datas.count;
        if (productsNum == 0)
        {
            [noneProductView setHidden:NO];
            [findProductButton setHidden:NO];
            [tView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        else
        {
            [noneProductView setHidden:YES];
            [findProductButton setHidden:YES];
            [tView setHidden:NO];
        }
        [tView reloadData];
        [tView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
        [tView.mj_header endRefreshing];
    }];
}

- (void)loadEndedTableViewData:(id)sender
{
    buttonTag = 1;
    [tView.mj_header beginRefreshing];
    standingButton.tintColor = ZTGRAY;
    ingButton.tintColor = ZTGRAY;
    endedButton.tintColor = ZTBLUE;
    [standingButton setUserInteractionEnabled:YES];
    [ingButton setUserInteractionEnabled:YES];
    [endedButton setUserInteractionEnabled:NO];
}

- (void)loadEndedTableViewData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/myPurchases/99/4"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        datas = [self packgeData:responseObject];
        productsNum = (int)datas.count;
        if (productsNum == 0)
        {
            [noneProductView setHidden:NO];
            [tView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        else
        {
            [noneProductView setHidden:YES];
            [tView setHidden:NO];
        }
        [tView reloadData];
        [tView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
        [tView.mj_header endRefreshing];
    }];
    [findProductButton setHidden:YES];
}

- (void)quitInvest:(UIButton*)sender
{
    if (!standingButton.userInteractionEnabled)
    {
        QuitAlertView *view = [[QuitAlertView alloc]initWithFrame:CGRectMake(self.navigationController.view.frame.size.width/2-140, self.navigationController.view.frame.size.height/2-50.5, 280, 106)];
        view.block = ^(id object)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/fofProd/quitPurchase/%@?tradePassword=%@", orderNo, @""]];
            [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
                    hud.labelText = @"退出成功";
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

        };
        [self.navigationController.view addSubview:view];
        [view showView];
    }
    
    if (!ingButton.userInteractionEnabled)
    {
        QuitAlertView *qview = [[QuitAlertView alloc]initWithFrame:CGRectMake(self.navigationController.view.frame.size.width/2-140, self.navigationController.view.frame.size.height/2-50.5, 280, 106)];
        qview.block = ^(id object)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if ([userDefault boolForKey:ISTPNUMERIC])
            {
                TradePswdView *view = [[TradePswdView alloc]initWithFrame:self.navigationController.view.frame];
                view.block = ^(NSString *tradePswd) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/fofProd/quitPurchase/%@?tradePassword=%@", orderNo,tradePswd]];
                    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
                            hud.labelText = @"转入成功";
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
                };
                [self.navigationController.view addSubview:view];
                [view showView];
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入交易密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    textField.secureTextEntry = YES;
                    textField.returnKeyType = UIReturnKeyDone;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    UITextField *tradePswdTextField = alertController.textFields.firstObject;
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
                    [self quit:tradePswdTextField.text orderNO:orderNo];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:confirmAction];
                confirmAction.enabled = NO;
                [self presentViewController:alertController animated:YES completion:nil];
            }

        };
        [self.navigationController.view addSubview:qview];
        [qview showView];
    }
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *tradePswdTextField = alertController.textFields.firstObject;
        UIAlertAction *confirmAction = alertController.actions.lastObject;
        confirmAction.enabled = tradePswdTextField.text.length >= 6;
    }
}

- (void)quit:(NSString *)tradePswd orderNO:(NSString *)orderNumber
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/fofProd/quitPurchase/%@?tradePassword=%@", orderNumber,tradePswd]];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
            hud.labelText = @"转入成功";
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

- (void)toAgreemet:(UIButton*)sender
{
    WebDetailViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
    NSString *productID = [NSString stringWithFormat:@"%@",[datas[sender.tag] objectForKey:@"id"]];
    [vc setURL:[NSString stringWithFormat:@"%@Wap/WebView/InvestAgreement4M?productCode=%@", BASEURL, productID]];
    vc.title = @"专投网产品服务协议";
    [[self navigationController]pushViewController:vc animated:YES];
}

#pragma TableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 10;
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == productsNum-1)
        return 10;
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return productsNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = datas[indexPath.section];
    NSString *str = [data objectForKey:@"productType"];
    if (!endedButton.userInteractionEnabled)
    {
        if ([str isEqualToString:@"固定收益"])
        {
            return 162;
        }
        else
        {
            return 203;
        }
    }
    else
    {
        if ([str isEqualToString:@"固定收益"])
        {
            return 203;
        }
        else
        {
            return 244;
        }

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = datas[indexPath.section];
    NSString *str = [data objectForKey:@"productType"];
    if (!endedButton.userInteractionEnabled)
    {
        if ([str isEqualToString:@"固定收益"])
        {
            NSString *identifier = @"WenjianEndedTableViewCell";
            WenjianEndedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[WenjianEndedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text = [((NSString*)[data objectForKey:@"productName"]) substringFromIndex:3];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"amount"]).doubleValue]]];
            cell.profitNumLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"paidInterestAmount"]).doubleValue]]];
            cell.standingNumLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"paidStandbyIntAmount"]).doubleValue]]];
            [cell.contractButton addTarget:self action:@selector(toAgreemet:) forControlEvents:UIControlEventTouchUpInside];
            cell.contractButton.tag = indexPath.section;
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"additionalInterestRate"]].intValue > 0)
            {
                cell.profitTitleLabel.text = [NSString stringWithFormat:@"固定收益(+%d%%)",[NSString stringWithFormat:@"%@",[data objectForKey:@"additionalInterestRate"]].intValue];
            }
            else
            {
                cell.profitTitleLabel.text = @"固定收益";
            }
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"standbySubsidyRate"]].intValue > 0)
            {
                cell.standingTitleLabel.text = [NSString stringWithFormat:@"募集期收益(+%d%%)",[NSString stringWithFormat:@"%@",[data objectForKey:@"standbySubsidyRate"]].intValue];
            }
            else
            {
                cell.standingTitleLabel.text = @"募集期收益";
            }
            
            return cell;
        }
        else
        {
            NSString *identifier = @"ZongheEndedTableViewCell";
            ZongheEndedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[ZongheEndedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text =[((NSString*)[data objectForKey:@"productName"]) substringFromIndex:3];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"amount"]).doubleValue]]];
            cell.guideProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"paidInterestAmount"]).doubleValue]]];
            cell.floatProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"paidShareAmount"]).doubleValue]]];
            cell.standingNumLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"paidStandbyIntAmount"]).doubleValue]]];
            [cell.contractButton addTarget:self action:@selector(toAgreemet:) forControlEvents:UIControlEventTouchUpInside];
            cell.contractButton.tag = indexPath.section;
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"additionalInterestRate"]].intValue > 0)
            {
                cell.guideProfitTitleLabel.text = [NSString stringWithFormat:@"固定收益(+%d%%)",[NSString stringWithFormat:@"%@",[data objectForKey:@"additionalInterestRate"]].intValue];
            }
            else
            {
                cell.guideProfitTitleLabel.text = @"固定收益";
            }
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"standbySubsidyRate"]].intValue > 0)
            {
                cell.standingTitleLabel.text = [NSString stringWithFormat:@"募集期收益(+%d%%)",[NSString stringWithFormat:@"%@",[data objectForKey:@"standbySubsidyRate"]].intValue];
            }
            else
            {
                cell.standingTitleLabel.text = @"募集期收益";
            }
            
            return cell;
        }

    }
    else
    {
        if ([str isEqualToString:@"固定收益"])
        {
            NSString *identifier = @"WenjianIngTableViewCell";
            WenjianIngTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[WenjianIngTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text = [((NSString*)[data objectForKey:@"productName"]) substringFromIndex:3];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"amount"]).doubleValue]]];
            [cell.contractButton addTarget:self action:@selector(toAgreemet:) forControlEvents:UIControlEventTouchUpInside];
            cell.contractButton.tag = indexPath.section;
            if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]] isEqualToString:@"筹款中"])
            {
                cell.profitLabel.text = @"尚未操盘";
                cell.profitLabel.textColor = ZTGRAY;
            }
            else
            {
                cell.profitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"paidInterestAmount"]).doubleValue]]];
            }
            cell.timeLabel.text = [data objectForKey:@"endDateDisplay"];
            if ([[data objectForKey:@"isFresh"] boolValue] == YES) {
                orderNo = [NSString stringWithFormat:@"%@", [data objectForKey:@"orderNo"]];
            }
            [cell.quitButton addTarget:self action:@selector(quitInvest:) forControlEvents:UIControlEventTouchUpInside];
            if ([NSString stringWithFormat:@"%@", [data objectForKey:@"quitable"]].boolValue)
            {
                cell.quitButton.hidden = NO;
            }
            else
            {
                cell.quitButton.hidden = YES;
            }
            cell.standingNumLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"paidStandbyIntAmount"]).doubleValue]]];
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"additionalInterestRate"]].intValue > 0)
            {
                cell.profitTitleLabel.text = [NSString stringWithFormat:@"已派固定收益(+%d%%)",[NSString stringWithFormat:@"%@",[data objectForKey:@"additionalInterestRate"]].intValue];
            }
            else
            {
                cell.profitTitleLabel.text = @"已派固定收益";
            }
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"standbySubsidyRate"]].intValue > 0)
            {
                cell.standingTitleLabel.text = [NSString stringWithFormat:@"已派募集期收益(+%d%%)",[NSString stringWithFormat:@"%@",[data objectForKey:@"standbySubsidyRate"]].intValue];
            }
            else
            {
                cell.standingTitleLabel.text = @"已派募集期收益";
            }
            
            return cell;
        }
        else
        {
            NSString *identifier = @"ZongheIngTableViewCell";
            ZongheIngTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[ZongheIngTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text = [((NSString*)[data objectForKey:@"productName"]) substringFromIndex:3];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"amount"]).doubleValue]]];
            [cell.contractButton addTarget:self action:@selector(toAgreemet:) forControlEvents:UIControlEventTouchUpInside];
            cell.contractButton.tag = indexPath.section;
            if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]] isEqualToString:@"筹款中"])
            {
                cell.guideProfitLabel.text = @"尚未操盘";
                cell.guideProfitLabel.textColor = ZTGRAY;
                cell.floatProfitLabel.text = @"尚未操盘";
                cell.floatProfitLabel.textColor = ZTGRAY;
            }
            else
            {
                cell.guideProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"paidInterestAmount"]).doubleValue]]];
                if ([NSString stringWithFormat:@"%@", [data objectForKey:@"yearProfitNow"]].intValue != -1)
                {
                    cell.floatProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"todaysSharedPL"]).doubleValue]]];
                    cell.floatProfitLabel.textColor = ZTLIGHTRED;
                }
                else
                {
                    cell.floatProfitLabel.text = @"暂不计算";
                    cell.floatProfitLabel.textColor = ZTGRAY;
                }
            }
            cell.timeLabel.text = [data objectForKey:@"endDateDisplay"];
            if ([[data objectForKey:@"isFresh"] boolValue] == YES) {
                orderNo = [NSString stringWithFormat:@"%@", [data objectForKey:@"orderNo"]];
            }
            [cell.quitButton addTarget:self action:@selector(quitInvest:) forControlEvents:UIControlEventTouchUpInside];
            if ([NSString stringWithFormat:@"%@", [data objectForKey:@"quitable"]].boolValue)
            {
                cell.quitButton.hidden = NO;
            }
            else
            {
                cell.quitButton.hidden = YES;
            }
            cell.standingNumLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"paidStandbyIntAmount"]).doubleValue]]];
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"additionalInterestRate"]].intValue > 0)
            {
                cell.guideProfitTitleLabel.text = [NSString stringWithFormat:@"已派固定收益(+%d%%)",[NSString stringWithFormat:@"%@",[data objectForKey:@"additionalInterestRate"]].intValue];
            }
            else
            {
                cell.guideProfitTitleLabel.text = @"已派固定收益";
            }
            if ([NSString stringWithFormat:@"%@",[data objectForKey:@"standbySubsidyRate"]].intValue > 0)
            {
                cell.standingTitleLabel.text = [NSString stringWithFormat:@"已派募集期收益(+%d%%)",[NSString stringWithFormat:@"%@",[data objectForKey:@"standbySubsidyRate"]].intValue];
            }
            else
            {
                cell.standingTitleLabel.text = @"已派募集期收益";
            }
            
            return cell;
        }

    }
}

- (void)didReceivePush:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RECEIVEPUSH" object:nil];
    if ([self isCurrentViewControllerVisible:self])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISLASTPUSHHANDLE];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (app.userInfo.count > 0)
        {
            NSString *afterOpen = [app.userInfo objectForKey:@"after_open"];
            if ([afterOpen isEqualToString:@"go_activity"])
            {
                NSString *afterOpen = [app.userInfo objectForKey:@"after_open"];
                if ([afterOpen isEqualToString:@"go_activity"])
                {
                    NSString *activity = [app.userInfo objectForKey:@"activity"];
                    if ([activity isEqualToString:@"endedDq"])
                    {
                        [self.navigationController setNavigationBarHidden:NO];
                        [self loadEndedTableViewData:endedButton];
                    }
                    else
                    {
                        NSLog(@"dsfdsdfsds");
                        [[self tabBarController] setSelectedIndex:1];
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }
                }
            }
            else if ([afterOpen isEqualToString:@"go_url"])
            {
                NSLog(@"fsfsfsfsfsfsfs");
                NSString *url = [app.userInfo objectForKey:@"url"];
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                WebDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
                [vc setURL:url];
                vc.title = @"专投公告";
                [[self navigationController]pushViewController:vc animated:YES];
            }
        }
    }
}

-(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

@end
