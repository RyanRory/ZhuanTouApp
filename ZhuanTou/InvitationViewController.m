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
    UIBarButtonItem *ruleItem = [[UIBarButtonItem alloc]initWithTitle:@"活动介绍" style:UIBarButtonItemStylePlain target:self action:@selector(toIntro:)];
    self.navigationItem.rightBarButtonItem = ruleItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,nil] forState:UIControlStateNormal];
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
    AFHTTPRequestOperationManager *userinfomanager = [AFHTTPRequestOperationManager manager];
    NSString *userinfoURL = [BASEURL stringByAppendingString:@"api/account/getUserInfoInAPP"];
    [userinfomanager GET:userinfoURL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            realNameString = [responseObject objectForKey:@"realName"];
            if ([realNameString isEqual:[NSNull null]]){
                realNameString = [responseObject objectForKey:@"userName"];
            }
            phonenumString = [responseObject objectForKey:@"mobilePhone"];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePush:) name:@"RECEIVEPUSH" object:nil];
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
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
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

- (void)toIntro:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefault boolForKey:ISLOGIN];
    if (!flag)
    {
        UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
        [[self tabBarController] presentViewController:nav animated:YES completion:nil];
    }
    else{
        WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
        vc.title = @"活动介绍";
        [vc setURL:[NSString stringWithFormat:@"%@Activities/Recommend/Welfare?hideAll",BASEURL]];
        [[self navigationController]pushViewController:vc animated:YES];
    }
    
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
        return 3;
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
                
//            case 2:
//                cell.image.image = [UIImage imageNamed:@"weibo.png"];
//                cell.label.text = @"新浪微博";
//                break;
                
            case 2:
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
    if (!invitationButton.userInteractionEnabled)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:@"api/article/appInviteSettings"];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary*responseObject) {
            NSLog(@"%@", responseObject);
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[responseObject objectForKey:@"appInvitePic"]]]];
            [hud hide:YES];
            if (indexPath.row == 0){
                [self sendLinkContent:WXSceneSession articleImage:image articleTitle:[responseObject objectForKey:@"appInviteTitle"] articleDescription:[responseObject objectForKey:@"appInviteDesc"] articleLink:[responseObject objectForKey:@"appInviteLink"]];
            }
            else if (indexPath.row == 1){
                [self sendLinkContent:WXSceneTimeline articleImage:image articleTitle:[responseObject objectForKey:@"appInviteTitle"] articleDescription:[responseObject objectForKey:@"appInviteDesc"] articleLink:[responseObject objectForKey:@"appInviteLink"]];
            }
            else if (indexPath.row == 2){
                [self sendNewsMessageWithLocalImage:[responseObject objectForKey:@"appInvitePic"] articleTitle:[responseObject objectForKey:@"appInviteTitle"] articleDescription:[responseObject objectForKey:@"appInviteDesc"] articleLink:[responseObject objectForKey:@"appInviteLink"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
        }];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sendLinkContent:(int)scene articleImage:(UIImage*)image articleTitle:(NSString*)title articleDescription:(NSString*)description articleLink:(NSString*)link
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [NSString stringWithFormat:@"%@rc=%@", link, phonenumString];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (void) sendNewsMessageWithLocalImage:(NSString*)previewImageUrl articleTitle:(NSString*)articleTitle articleDescription:(NSString*)articleDescription articleLink:(NSString*)link
{
    NSString *utf8String = [NSString stringWithFormat:@"%@rc=%@", link, phonenumString];
    //NSURL *url = [NSURL URLWithString:[BASEURL stringByAppendingString:[NSString stringWithFormat:@"Activities/Recommend/Invited?referCode=%@&name=%@", phonenumString, realNameString]]];
    NSURL *url = [[NSURL alloc] initWithString:[utf8String stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *title = articleTitle;
    NSString *description = articleDescription;
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104913119" andDelegate:self];
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:url
                                title:title
                                description:@""
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //分享到QZone
    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}

-(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
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
                NSString *activity = [app.userInfo objectForKey:@"activity"];
                if ([activity isEqualToString:@"endedDq"])
                {
                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    DingqiViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"DingqiViewController"];
                    vc.buttonTag = 1;
                    [[self navigationController]pushViewController:vc animated:YES];
                }
                else
                {
                    [[self navigationController] popToRootViewControllerAnimated:NO];
                    [[self tabBarController] setSelectedIndex:1];
                }
            }
            else if ([afterOpen isEqualToString:@"go_url"])
            {
                if (![[NSUserDefaults standardUserDefaults] boolForKey:ISURLSHOW])
                {
                    NSLog(@"fsfsfsfsfsfsfs");
                    NSString *url = [app.userInfo objectForKey:@"url"];
                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    WebDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
                    [vc setURL:url];
                    vc.title = [app.userInfo objectForKey:@"alert"];
                    [[self navigationController]pushViewController:vc animated:YES];
                }
            }
        }
    }
    
}



@end
