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
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    easterEggs = 0;
    
    tView.showsVerticalScrollIndicator = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    return 44;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
        return 2;
    else
        return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier0 = @"HelpCommonTableViewCell";
    static NSString *identifier1 = @"HelpDescriptionTableViewCell";
    
    if ((indexPath.section == 1) && (indexPath.row == 2))
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
//    }else if((indexPath.section == 1) && (indexPath.row == 2)){
//        HelpDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
//        if (!cell)
//        {
//            cell = [[HelpDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
//        }
//
//        cell.titleLabel.text = @"公众号";
//        cell.descriptionLabel.text = @"ilovezhuantou";
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    else if ((indexPath.section == 2) && (indexPath.row == 1))
    {
        HelpDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell)
        {
            cell = [[HelpDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        cell.titleLabel.text = @"版本号";
        cell.descriptionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
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
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"微信公众号";
            }
            else
            {
                cell.titleLabel.text = @"QQ联系";
            }
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
            CommonQuestionViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"CommonQuestionViewController"];
            [[self navigationController]pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if ([userDefault boolForKey:ISLOGIN])
            {
                FeedbackViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
                [[self navigationController]pushViewController:vc animated:YES];
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *gotoLogin = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                    [[self tabBarController] presentViewController:nav animated:YES completion:nil];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:gotoLogin];
                [alertController addAction:cancel];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        else
        {
            NSString *str =  [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",1055235910];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"ilovezhuantou";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"复制成功" message:@"微信号ilovezhuantou已经复制，请在微信里粘贴并搜索" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *gotoLogin = [UIAlertAction actionWithTitle:@"去微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                if ([WXApi isWXAppInstalled]) {
                    NSString *str = [NSString stringWithFormat:@"weixin://qr/%@",@""];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
                else
                {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"请安装微信";
                    hud.removeFromSuperViewOnHide = YES;
                    
                    [hud hide:YES afterDelay:1.5];
                }
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:gotoLogin];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else if (indexPath.row == 1)
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
            {
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=362236128&version=1&src_type=web"];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                webView.delegate = self;
                [webView loadRequest:request];
                [self.view addSubview:webView];
            }
            else
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"请安装QQ";
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:1.5];
            }
            
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"工作时间：9:00 ~ 19:00" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"呼叫  400-698-9861" style:UIAlertActionStyleDefault handler:^(UIAlertAction* call){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006989861"]];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:callAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            AboutViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"AboutViewController"];
            [[self navigationController]pushViewController:vc animated:YES];
        }
        else
        {
            easterEggs++;
            if (easterEggs == 11)
            {
                [self easterEggsAction];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 彩蛋~~
- (void)easterEggsAction
{
    
}

#pragma ActionSheet
- (void)callUs
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18616950387"]];
}

@end
