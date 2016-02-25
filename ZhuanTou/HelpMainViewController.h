//
//  HelpMainViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/23.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpCommonTableViewCell.h"
#import "HelpDescriptionTableViewCell.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "CommonQuestionViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface HelpMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate>
{
    int easterEggs;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;

@end
