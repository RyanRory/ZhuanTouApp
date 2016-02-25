//
//  WebDetailViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/26.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitationViewController.h"

@interface WebDetailViewController : UIViewController<UIWebViewDelegate>
{
    NSString *url;
    MBProgressHUD *hud;
    NSTimer *timer;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *reloadButton;
@property (readwrite, nonatomic) BOOL showInvite;
@property (strong, nonatomic) NSString *inviteTitle;

- (void)setURL:(NSString*)str;

@end
