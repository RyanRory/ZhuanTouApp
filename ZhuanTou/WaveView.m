//
//  WaveView.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/20.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "WaveView.h"

@implementation WaveView

@synthesize waveImageView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        waveImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 86, 430, 106)];
        UIImage *waveImage = [UIImage imageNamed:@"wave.png"];
        waveImage = [waveImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        waveImageView.image = waveImage;
        waveImageView.tintColor = ZTBLUE;
        [self addSubview:waveImageView];
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)startAnimation
{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:3.0f];
    [waveImageView setFrame:CGRectMake(-344, -20, waveImageView.frame.size.width, waveImageView.frame.size.height)];
    [UIView commitAnimations];
}

@end
