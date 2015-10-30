//
//  ProductMainViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/15.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductMainViewController.h"

@interface ProductMainViewController ()

@end

@implementation ProductMainViewController

@synthesize wenjianButton, zongheButton, huoqiButton;
@synthesize featureButton1, featureButton2, featureButton3, detailButton;
@synthesize bigRateLabel, monthNumLabel, moryLabel, percentLabel, rateContentLabel, bgCircleImageView, circleImageView, huoqiBgImageView1, huoqiBgImageView2;
@synthesize productsBeforeButton;
@synthesize smallRateLabel, rightView;
@synthesize amountLabel, timeLabel, buyButton;
@synthesize bgView, triangleImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [wenjianButton addTarget:self action:@selector(clickWenjianButton:) forControlEvents:UIControlEventTouchUpInside];
    [zongheButton addTarget:self action:@selector(clickZongheButton:) forControlEvents:UIControlEventTouchUpInside];
    [huoqiButton addTarget:self action:@selector(clickHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    
    [productsBeforeButton setTitle:[NSString stringWithFormat:@"查看\n往期产品"] forState:UIControlStateNormal];
    [productsBeforeButton setHidden:YES];
    productsBeforeButton.titleLabel.numberOfLines = 0;
    productsBeforeButton.titleLabel.textAlignment = 1;
    [productsBeforeButton addTarget:self action:@selector(goToProductsBefore:) forControlEvents:UIControlEventTouchUpInside];
    
    [featureButton1 setUserInteractionEnabled:NO];
    [featureButton2 setUserInteractionEnabled:NO];
    [featureButton3 setUserInteractionEnabled:NO];
    [detailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    bigRateLabel.format = @"%d";
    
    buyButton.layer.cornerRadius = 3;
    [buyButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    
    [wenjianButton setUserInteractionEnabled:NO];
    wenjianButton.tintColor = ZTLIGHTRED;
    zongheButton.tintColor = ZTGRAY;
    huoqiButton.tintColor = ZTGRAY;
    
    style = WENJIAN;
}

- (void)viewDidAppear:(BOOL)animated
{
    ZTTabBarViewController *tabBarVC = (ZTTabBarViewController*)[self tabBarController];
    style = [tabBarVC getStyle];
    if (frame.origin.x == 0) frame = huoqiBgImageView1.frame;
    if (bgPoint.x == 0) bgPoint = CGPointMake(bgCircleImageView.frame.origin.x + bgCircleImageView.frame.size.width/2+10, bgCircleImageView.frame.origin.y+bgCircleImageView.frame.size.height/2);
    if (point.x == 0) point = CGPointMake(bgCircleImageView.frame.origin.x - huoqiBgImageView1.frame.origin.x + 20, bgCircleImageView.frame.origin.y - frame.origin.y + 5);

    if ([style isEqualToString:HUOQI])
    {
        huoqiButton.tintColor = ZTRED;
        [huoqiButton setUserInteractionEnabled:NO];
        [wenjianButton setUserInteractionEnabled:YES];
        [zongheButton setUserInteractionEnabled:YES];
        wenjianButton.tintColor = ZTGRAY;
        zongheButton.tintColor = ZTGRAY;
        [self setupHuoqi];
    }
    else if ([style isEqualToString:ZONGHE])
    {
        zongheButton.tintColor = ZTBLUE;
        [zongheButton setUserInteractionEnabled:NO];
        [wenjianButton setUserInteractionEnabled:YES];
        [huoqiButton setUserInteractionEnabled:YES];
        wenjianButton.tintColor = ZTGRAY;
        huoqiButton.tintColor = ZTGRAY;
        [self setupZonghe];
    }
    else
    {
        wenjianButton.tintColor = ZTLIGHTRED;
        [wenjianButton setUserInteractionEnabled:NO];
        [zongheButton setUserInteractionEnabled:YES];
        [huoqiButton setUserInteractionEnabled:YES];
        zongheButton.tintColor = ZTGRAY;
        huoqiButton.tintColor = ZTGRAY;
        [self setupWenjian];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([style isEqualToString:HUOQI])
    {
        [huoqiBgImageView1 setFrame:frame];
        [huoqiBgImageView2 setFrame:frame];
    }
}

- (void)setupWenjian
{
    [bgCircleImageView.layer removeAllAnimations];
    [rightView setHidden:YES];
    [moryLabel setHidden:NO];
    [monthNumLabel setHidden:NO];
    [productsBeforeButton setHidden:YES];
    [huoqiBgImageView1 setHidden:YES];
    [huoqiBgImageView1 setFrame:frame];
    [huoqiBgImageView2 setHidden:YES];
    [huoqiBgImageView2 setFrame:frame];
    [bgCircleImageView setHidden:NO];
    bgView.backgroundColor = ZTLIGHTRED;
    triangleImageView.image = [UIImage imageNamed:@"wenjianTriangle.png"];
    circleImageView.image = [UIImage imageNamed:@"wenjian.png"];
    bigRateLabel.textColor = ZTLIGHTRED;
    percentLabel.textColor = ZTLIGHTRED;
    rateContentLabel.textColor = ZTLIGHTRED;
    rateContentLabel.text = @"固定年化收益率";
    productsBeforeButton.tintColor = ZTLIGHTRED;
    [featureButton1 setImage:[UIImage imageNamed:@"profitIcon.png"] forState:UIControlStateNormal];
    [featureButton1 setTitle:@"较高收益" forState:UIControlStateNormal];
    [buyButton setBackgroundColor:ZTLIGHTRED];
    
    [self bgCircleAnimation];
    
    [bigRateLabel countFromZeroTo:12 withDuration:0.8f];
    
}

- (void)setupZonghe
{
    [bgCircleImageView.layer removeAllAnimations];
    [rightView setHidden:NO];
    [moryLabel setHidden:NO];
    [monthNumLabel setHidden:NO];
    [productsBeforeButton setHidden:NO];
    [huoqiBgImageView1 setHidden:YES];
    [huoqiBgImageView1 setFrame:frame];
    [huoqiBgImageView2 setHidden:YES];
    [huoqiBgImageView2 setFrame:frame];
    [bgCircleImageView setHidden:NO];
    bgView.backgroundColor = ZTBLUE;
    triangleImageView.image = [UIImage imageNamed:@"zongheTriangle.png"];
    circleImageView.image = [UIImage imageNamed:@"zonghe.png"];
    bigRateLabel.textColor = ZTBLUE;
    percentLabel.textColor = ZTBLUE;
    rateContentLabel.textColor = ZTBLUE;
    rateContentLabel.text = @"预期年化收益率";
    productsBeforeButton.tintColor = ZTBLUE;
    [featureButton1 setImage:[UIImage imageNamed:@"profitIcon.png"] forState:UIControlStateNormal];
    [featureButton1 setTitle:@"超高收益" forState:UIControlStateNormal];
    [buyButton setBackgroundColor:ZTBLUE];
    
    [self bgCircleAnimation];
    
    [bigRateLabel countFromZeroTo:14 withDuration:0.8f];
}

- (void)setupHuoqi
{
    [rightView setHidden:YES];
    [moryLabel setHidden:YES];
    [monthNumLabel setHidden:YES];
    [productsBeforeButton setHidden:YES];
    [huoqiBgImageView1 setHidden:NO];
    [huoqiBgImageView2 setHidden:NO];
    [bgCircleImageView setHidden:YES];
    bgView.backgroundColor = ZTRED;
    triangleImageView.image = [UIImage imageNamed:@"huoqiTriangle.png"];
    circleImageView.image = [UIImage imageNamed:@"huoqi.png"];
    bigRateLabel.textColor = ZTRED;
    percentLabel.textColor = ZTRED;
    rateContentLabel.textColor = ZTRED;
    rateContentLabel.text = @"复合年化收益率";
    productsBeforeButton.tintColor = ZTRED;
    [featureButton1 setImage:[UIImage imageNamed:@"quickIcon.png"] forState:UIControlStateNormal];
    [featureButton1 setTitle:@"随存随取" forState:UIControlStateNormal];
    [buyButton setBackgroundColor:ZTRED];
    
    //动画效果
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:0.8f];
    [huoqiBgImageView1 setFrame:CGRectMake(frame.origin.x + point.x, frame.origin.y + point.y, frame.size.width, frame.size.height)];
    [huoqiBgImageView2 setFrame:CGRectMake(frame.origin.x - point.x, frame.origin.y - point.y, frame.size.width, frame.size.height)];
    [bigRateLabel countFromZeroTo:6 withDuration:0.8f];
    [UIView commitAnimations];
    
    
}

- (void)clickWenjianButton:(id)sender
{
    [self setupWenjian];
    wenjianButton.tintColor = ZTLIGHTRED;
    [wenjianButton setUserInteractionEnabled:NO];
    [zongheButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
    zongheButton.tintColor = ZTGRAY;
    huoqiButton.tintColor = ZTGRAY;
    ZTTabBarViewController *tabBarVC = (ZTTabBarViewController*)[self tabBarController];
    [tabBarVC setStyle:WENJIAN];
}

- (void)clickZongheButton:(id)sender
{
    [self setupZonghe];
    zongheButton.tintColor = ZTBLUE;
    [zongheButton setUserInteractionEnabled:NO];
    [wenjianButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
    wenjianButton.tintColor = ZTGRAY;
    huoqiButton.tintColor = ZTGRAY;
    ZTTabBarViewController *tabBarVC = (ZTTabBarViewController*)[self tabBarController];
    [tabBarVC setStyle:ZONGHE];
}

- (void)clickHuoqi:(id)sender
{
    [self setupHuoqi];
    huoqiButton.tintColor = ZTRED;
    [huoqiButton setUserInteractionEnabled:NO];
    [wenjianButton setUserInteractionEnabled:YES];
    [zongheButton setUserInteractionEnabled:YES];
    wenjianButton.tintColor = ZTGRAY;
    zongheButton.tintColor = ZTGRAY;
    ZTTabBarViewController *tabBarVC = (ZTTabBarViewController*)[self tabBarController];
    [tabBarVC setStyle:HUOQI];
}

- (void)bgCircleAnimation
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 1.5f;
    pathAnimation.repeatCount = 1;
    //设置运转动画的路径
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, bgPoint.x, bgPoint.y, 10, M_PI, 3 * M_PI, 0);
    pathAnimation.path = curvedPath;
    [bgCircleImageView.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
}

- (void)goToDetail:(id)sender
{
    
}

- (void)goToProductsBefore:(id)sender
{
    ProductsBeforeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductsBeforeViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)buyNow:(id)sender
{
    ProductBuyViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyViewController"];
    [vc setStyle:style];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
