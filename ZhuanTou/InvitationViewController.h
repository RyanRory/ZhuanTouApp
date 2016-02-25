//
//  InvitationViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/11.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitationTableViewCell.h"
#import "MyInvTableViewCell.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "AppDelegate.h"
#import "WebDetailViewController.h"

@interface InvitationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary *info;
    NSMutableArray *datas, *buffer;
    int dataNum;
    NSString *realNameString, *phonenumString;
}
@property (retain, nonatomic) TencentOAuth *tencentOAuth;

@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UIButton *invitationButton;
@property (strong, nonatomic) IBOutlet UIButton *myInvButton;

@end
