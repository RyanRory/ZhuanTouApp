//
//  ZTTabBarViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/15.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTTabBarViewController : UITabBarController<UITabBarControllerDelegate, UITabBarDelegate>

@property(readonly, nonatomic) NSUInteger lastSelectedIndex;
@property(readwrite, nonatomic) NSUInteger isRegister;

@end
