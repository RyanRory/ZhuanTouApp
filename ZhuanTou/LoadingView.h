//
//  LoadingView.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/9/30.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property(strong, nonatomic) UIImageView *midImageView;
@property(strong, nonatomic) UIImageView *rotateImageView;

- (void)startAnimation;

- (void)stopAnimation;

@end
