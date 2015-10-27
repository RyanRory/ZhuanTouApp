//
//  AutoViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/20.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoTableViewCell.h"

@interface AutoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    BOOL switchOn;
    int t;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;

- (void)setSwitchOn:(BOOL)flag;

@end
