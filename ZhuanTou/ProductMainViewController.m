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
    [[self navigationController]setNavigationBarHidden:NO animated:YES];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [wenjianButton addTarget:self action:@selector(clickWenjianButton:) forControlEvents:UIControlEventTouchUpInside];
    [zongheButton addTarget:self action:@selector(clickZongheButton:) forControlEvents:UIControlEventTouchUpInside];
    [huoqiButton addTarget:self action:@selector(clickHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    
    [productsBeforeButton setTitle:[NSString stringWithFormat:@"查看\n往期收益"] forState:UIControlStateNormal];
    [productsBeforeButton setHidden:YES];
    productsBeforeButton.titleLabel.numberOfLines = 0;
    productsBeforeButton.titleLabel.textAlignment = 1;
    [productsBeforeButton addTarget:self action:@selector(goToProductsBefore:) forControlEvents:UIControlEventTouchUpInside];
    
    [featureButton1 setUserInteractionEnabled:NO];
    [featureButton2 setUserInteractionEnabled:NO];
    [featureButton3 setUserInteractionEnabled:NO];
    [detailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    buyButton.layer.cornerRadius = 3;
    [buyButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setUserInteractionEnabled:NO];
    [buyButton setAlpha:0.6f];
    
    [zongheButton setUserInteractionEnabled:NO];
    wenjianButton.tintColor = ZTGRAY;
    zongheButton.tintColor = ZTBLUE;
    huoqiButton.tintColor = ZTGRAY;
    
    style = ZONGHE;
    wenjianFlag = false;
    zongheFlag = false;
    huoqiFlag = false;
}

- (void)viewDidAppear:(BOOL)animated
{
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
    wenjianFlag = false;
    zongheFlag = false;
    huoqiFlag = false;
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
    timeLabel.hidden = NO;
    if (!wenjianFlag)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.operationQueue cancelAllOperations]; 
        NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/0"];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            wenjianData = [NSDictionary dictionaryWithDictionary:responseObject];
            idCode = [wenjianData objectForKey:@"id"];
            NSString *numStr = [NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"interestRate"]];
            if ([numStr rangeOfString:@"."].location != NSNotFound)
            {
                bigRateLabel.format = @"%0.1f";
                bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:38.0f];
                [bigRateLabel countFromZeroTo:numStr.doubleValue withDuration:0.8f];
            }
            else
            {
                bigRateLabel.format = @"%d";
                bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
                [bigRateLabel countFromZeroTo:numStr.intValue withDuration:0.8f];
            }
            monthNumLabel.text = [NSString stringWithFormat:@"%d",(((NSString*)[wenjianData objectForKey:@"noOfDays"]).intValue / 30)];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0"];
            amountLabel.text = [NSString stringWithFormat:@"产品规模：%@元",[NSString stringWithString:[formatter stringFromNumber:[wenjianData objectForKey:@"targetPurchaseAmount"]]]];
            timeLabel.text = [NSString stringWithFormat:@"%@开始抢购",[wenjianData objectForKey:@"startRaisingDate"]];
            bidableAmount = [NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"bidableAmount"]];
            [self bgCircleAnimation];
            wenjianFlag = true;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
        }];
    }
    else
    {
        idCode = [wenjianData objectForKey:@"id"];
        NSString *numStr = [NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"interestRate"]];
        if ([numStr rangeOfString:@"."].location != NSNotFound)
        {
            bigRateLabel.format = @"%0.1f";
            bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:38.0f];
            [bigRateLabel countFromZeroTo:numStr.doubleValue withDuration:0.8f];
        }
        else
        {
            bigRateLabel.format = @"%d";
            bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
            [bigRateLabel countFromZeroTo:numStr.intValue withDuration:0.8f];
        }
        monthNumLabel.text = [NSString stringWithFormat:@"%d",(((NSString*)[wenjianData objectForKey:@"noOfDays"]).intValue / 30)];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        amountLabel.text = [NSString stringWithFormat:@"产品规模：%@元",[NSString stringWithString:[formatter stringFromNumber:[wenjianData objectForKey:@"targetPurchaseAmount"]]]];
        timeLabel.text = [NSString stringWithFormat:@"%@开始抢购",[wenjianData objectForKey:@"startRaisingDate"]];
        bidableAmount = [NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"bidableAmount"]];
        [self bgCircleAnimation];
    }
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
    timeLabel.hidden = NO;
    
    if (!zongheFlag)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.operationQueue cancelAllOperations];
        NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/1"];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            zongheData = [NSDictionary dictionaryWithDictionary:responseObject];
            idCode = [zongheData objectForKey:@"id"];
            NSString *numStr = [NSString stringWithFormat:@"%@",[zongheData objectForKey:@"expectedReturn"]];
            if ([numStr rangeOfString:@"."].location != NSNotFound)
            {
                bigRateLabel.format = @"%0.1f";
                bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:38.0f];
                [bigRateLabel countFromZeroTo:numStr.doubleValue withDuration:0.8f];
            }
            else
            {
                bigRateLabel.format = @"%d";
                bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
                [bigRateLabel countFromZeroTo:numStr.intValue withDuration:0.8f];
            }
            monthNumLabel.text = [NSString stringWithFormat:@"%d",(((NSString*)[zongheData objectForKey:@"noOfDays"]).intValue / 30)];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0"];
            amountLabel.text = [NSString stringWithFormat:@"产品规模：%@元",[NSString stringWithString:[formatter stringFromNumber:[zongheData objectForKey:@"targetPurchaseAmount"]]]];
            timeLabel.text = [NSString stringWithFormat:@"%@开始抢购",[zongheData objectForKey:@"startRaisingDate"]];
            smallRateLabel.text = [NSString stringWithFormat:@"%@",[zongheData objectForKey:@"interestRate"]];
            bidableAmount = [NSString stringWithFormat:@"%@",[zongheData objectForKey:@"bidableAmount"]];
            [self bgCircleAnimation];
            zongheFlag = true;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
        }];
    }
    else
    {
        idCode = [zongheData objectForKey:@"id"];
        NSString *numStr = [NSString stringWithFormat:@"%@",[zongheData objectForKey:@"expectedReturn"]];
        if ([numStr rangeOfString:@"."].location != NSNotFound)
        {
            bigRateLabel.format = @"%0.1f";
            bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:38.0f];
            [bigRateLabel countFromZeroTo:numStr.doubleValue withDuration:0.8f];
        }
        else
        {
            bigRateLabel.format = @"%d";
            bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
            [bigRateLabel countFromZeroTo:numStr.intValue withDuration:0.8f];
        }
        monthNumLabel.text = [NSString stringWithFormat:@"%d",(((NSString*)[zongheData objectForKey:@"noOfDays"]).intValue / 30)];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        amountLabel.text = [NSString stringWithFormat:@"产品规模：%@元",[NSString stringWithString:[formatter stringFromNumber:[zongheData objectForKey:@"targetPurchaseAmount"]]]];
        timeLabel.text = [NSString stringWithFormat:@"%@开始抢购",[zongheData objectForKey:@"startRaisingDate"]];
        smallRateLabel.text = [NSString stringWithFormat:@"%@",[zongheData objectForKey:@"interestRate"]];
        bidableAmount = [NSString stringWithFormat:@"%@",[zongheData objectForKey:@"bidableAmount"]];
        [self bgCircleAnimation];
    }
    
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
    timeLabel.hidden = YES;
    
    if (!huoqiFlag)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.operationQueue cancelAllOperations];
        NSString *URL = [BASEURL stringByAppendingString:@"api/stat/ztbDesc4M"];
        [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            huoqiData = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *numStr = [NSString stringWithFormat:@"%@",[huoqiData objectForKey:@"interestRate"]];
            if ([numStr rangeOfString:@"."].location != NSNotFound)
            {
                bigRateLabel.format = @"%.1f";
                bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:38.0f];
                [bigRateLabel countFrom:0.0 to:numStr.doubleValue withDuration:0.8f];
            }
            else
            {
                bigRateLabel.format = @"%d";
                bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
                [bigRateLabel countFromZeroTo:numStr.intValue withDuration:0.8f];
            }
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0"];
            amountLabel.text = [NSString stringWithFormat:@"产品规模：%@元",[NSString stringWithString:[formatter stringFromNumber:[huoqiData objectForKey:@"totalAmount"]]]];
            bidableAmount = [NSString stringWithFormat:@"%@",[huoqiData objectForKey:@"bidableAmount"]];
            huoqiFlag = true;
            if ([NSString stringWithFormat:@"%@",[huoqiData objectForKey:@"bidableAmount"]].doubleValue > 0)
            {
                [buyButton setUserInteractionEnabled:YES];
                [buyButton setAlpha:1.0f];
            }
            else
            {
                [buyButton setUserInteractionEnabled:NO];
                [buyButton setAlpha:1.0f];
                buyButton.backgroundColor = ZTGRAY;
                [buyButton setTitle:@"已售完" forState:UIControlStateNormal];
            }
            //动画效果
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationDuration:0.8f];
            [huoqiBgImageView1 setFrame:CGRectMake(frame.origin.x + point.x, frame.origin.y + point.y, frame.size.width, frame.size.height)];
            [huoqiBgImageView2 setFrame:CGRectMake(frame.origin.x - point.x, frame.origin.y - point.y, frame.size.width, frame.size.height)];
            [UIView commitAnimations];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
        }];

    }
    else
    {
        NSString *numStr = [NSString stringWithFormat:@"%@",[huoqiData objectForKey:@"interestRate"]];
        if ([numStr rangeOfString:@"."].location != NSNotFound)
        {
            bigRateLabel.format = @"%0.1f";
            bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:38.0f];
            [bigRateLabel countFromZeroTo:numStr.doubleValue withDuration:0.8f];
        }
        else
        {
            bigRateLabel.format = @"%d";
            bigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
            [bigRateLabel countFromZeroTo:numStr.intValue withDuration:0.8f];
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        amountLabel.text = [NSString stringWithFormat:@"产品规模：%@元",[NSString stringWithString:[formatter stringFromNumber:[huoqiData objectForKey:@"totalAmount"]]]];;
        huoqiFlag = true;
        if ([NSString stringWithFormat:@"%@",[huoqiData objectForKey:@"bidableAmount"]].doubleValue > 0)
        {
            [buyButton setUserInteractionEnabled:YES];
            [buyButton setAlpha:1.0f];
        }
        else
        {
            [buyButton setUserInteractionEnabled:NO];
            [buyButton setAlpha:1.0f];
            buyButton.backgroundColor = ZTGRAY;
            [buyButton setTitle:@"已售完" forState:UIControlStateNormal];
        }
        bidableAmount = [NSString stringWithFormat:@"%@",[huoqiData objectForKey:@"bidableAmount"]];
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.8f];
        [huoqiBgImageView1 setFrame:CGRectMake(frame.origin.x + point.x, frame.origin.y + point.y, frame.size.width, frame.size.height)];
        [huoqiBgImageView2 setFrame:CGRectMake(frame.origin.x - point.x, frame.origin.y - point.y, frame.size.width, frame.size.height)];
        [UIView commitAnimations];
    }
    
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
    style = WENJIAN;
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
    style = ZONGHE;
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
    style = HUOQI;
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"建设中...";
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inbuilding.png"]];
    [hud hide:YES afterDelay:1.5f];
}

- (void)goToProductsBefore:(id)sender
{
    ProductsBeforeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductsBeforeViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)buyNow:(id)sender
{
    ProductBuyViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyViewController"];
    vc.style = style;
    vc.idOrCode = idCode;
    vc.bidableAmount = bidableAmount;
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
