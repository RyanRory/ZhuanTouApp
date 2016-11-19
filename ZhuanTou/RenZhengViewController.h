//
//  RenZhengViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/10/18.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenZhengViewController : UIViewController
{
    NSString *url;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (void)setURL:(NSString *)str;

@end
