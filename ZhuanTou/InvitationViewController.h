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

@interface InvitationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary *info;
    NSMutableArray *datas, *buffer;
    int dataNum;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UIButton *invitationButton;
@property (strong, nonatomic) IBOutlet UIButton *myInvButton;

@end
