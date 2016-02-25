//
//  LaunchScreenViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/19.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTTabBarViewController.h"
#import "WaveView.h"
#import "SetpasswordViewController.h"

@interface LaunchScreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *centerImageView;
@property (strong, nonatomic) IBOutlet WaveView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *discriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *remainImageView;

@end
