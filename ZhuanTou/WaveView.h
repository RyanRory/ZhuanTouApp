//
//  WaveView.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/20.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveView : UIView

@property (strong, nonatomic) UIImageView *waveImageView;

- (void)startAnimation;

@end
