//
//  NoticeCenterViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/26.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeCenterTableViewCell.h"
#import "WebDetailViewController.h"

@interface NoticeCenterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *notices;
    int noticesNum;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;

@end
