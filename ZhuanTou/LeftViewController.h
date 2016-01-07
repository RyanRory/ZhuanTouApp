//
//  LeftViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/21.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTTabBarViewController.h"
#import "LeftTableViewCell.h"

@interface LeftViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary *data;
}

@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tView;

- (void)setupData;

@end
