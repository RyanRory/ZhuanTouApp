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
        if (indexPath.row == 0){
            [self sendLinkContent:WXSceneSession];
        }
        else if (indexPath.row == 1){
            [self sendLinkContent:WXSceneTimeline];
        }
        else if (indexPath.row == 2){
            [self sendNewsMessageWithLocalImage];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) sendLinkContent:(int) scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"我给你送专投网福利了！";
    message.description = @"专投网新人活动三重壕礼，230元奖励等你拿，赶快来！";
    [message setThumbImage:[UIImage imageNamed:@"loginLogo.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"Activities/Recommend/Invited?referCode=%@&name=%@", phonenumString, realNameString]];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (void) sendNewsMessageWithLocalImage
{
    NSString *utf8String = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"Activities/Recommend/Invited?referCode=%@&name=%@", phonenumString, realNameString]];
    //NSURL *url = [NSURL URLWithString:[BASEURL stringByAppendingString:[NSString stringWithFormat:@"Activities/Recommend/Invited?referCode=%@&name=%@", phonenumString, realNameString]]];
    NSURL *url = [[NSURL alloc] initWithString:[utf8String stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *title = @"我给你送专投网福利了！";
    NSString *description = @"专投网新人活动三重壕礼，230元奖励等你拿，赶快来！";
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"loginLogo.png"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSString *previewImageUrl = @"https://mmbiz.qlogo.cn/mmbiz/QPNwM5MMglftcts729BarkLKBgmfNJdEtzOeLa35czyYvAVsYOZ0RfncxQNj6ib6kohnW4bGTfoVLkwdV1RibyOQ/0?wx_fmt=jpeg";
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104913119" andDelegate:self];
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:url
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    //QQApiCommonContentObject *newsObj = [QQApiCommonContentObject objectWithLayoutType: textArray:nil pictureArray:nil previewImageData:data];
    //QQApiURLObject *newsObj = [QQApiURLObject objectWithURL:[NSURL URLWithString:utf8String] title:title description:description previewImageData:data targetContentType:QQApiURLTargetTypeNews];
//    uint64_t cflag = 1;
//    [newsObj setCflag:cflag];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //分享到QZone
    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    [self handleSendResult:sent];
    
//    NSURL* url = [NSURL URLWithString:@"http://zhuantouwang.com"];
//    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104913119" andDelegate:self];
////    QQApiURLObject* img = [QQApiNewsObject objectWithURL:url title:@"123" description:@"456" previewImageData:data];
//    QQApiURLObject* img  = [QQApiURLObject objectWithURL:url title:@"123" description:@"456" previewImageData:data targetContentType:QQApiURLTargetTypeNotSpecified];
//    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
//    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//    //[QQApiCommonContentObject ];
//    
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//    //[QQApiInterface sendReq:req];
//    [self handleSendResult:sent];
//    //[self handleSendResult:sent];

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


@end
