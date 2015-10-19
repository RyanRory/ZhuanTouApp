//
//  HuoqiViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/18.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICountingLabel.h"

@interface HuoqiViewController : UIViewController

@property (strong, nonatomic) IBOutlet UICountingLabel *yesterdayProfitLabel;
@property (strong, nonatomic) IBOutlet UILabel *myPortionLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalProfitLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UIButton *drawButton;

@end
