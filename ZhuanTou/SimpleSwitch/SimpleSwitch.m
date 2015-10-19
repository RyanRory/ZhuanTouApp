//
//  SimplerSwitch.m
//  SimplerSwitch
//
//  Created by xiao haibo on 8/22/12.
//  Copyright (c) 2012 xiao haibo. All rights reserved.
//
//  github:https://github.com/xxhp/SimpleSwitchDemo
//  Email:xiao_hb@qq.com

//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
#import "UIView+InnerShadow.h"
#import "SimpleSwitch.h"
#import "TitleLayer.h"
#define kWIDTH 40
#define kHEIGHT 20
#define kDefaultTitleOn @""
#define kDefaultTitleOff @""
@interface SimpleSwitch()
-(void)setUpWithDefault;
@end

@implementation SimpleSwitch
@synthesize on;
@synthesize titleOn;
@synthesize titleOff;
@synthesize knobColor;
@synthesize fillColor;
#pragma mark -
#pragma mark init

- (id)init
{
    if ((self = [super init]))
    {
        [self setUpWithDefault];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
        self.frame = frame;
        [self setUpWithDefault];
        
	}
    
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self setUpWithDefault];
    }
    
    return self;
}

-(void)setUpWithDefault{
    self.backgroundColor = [UIColor clearColor] ;
    
    knobFrameOff = CGRectMake(1,1,self.bounds.size.width/2-2, self.bounds.size.height-2);
    knobFrameOn = CGRectMake(1+self.bounds.size.width/2,1,self.bounds.size.width/2-2, self.bounds.size.height-2);
   
    self.titleOn = kDefaultTitleOn;
    self.titleOff = kDefaultTitleOff;
    self.fillColor = ZTBLUE;
    self.knobColor = [UIColor whiteColor];
   
    on= NO;
    
    titleLayer = [[TitleLayer alloc] initWithOnString:self.titleOn offString:self.titleOff];
    titleLayer.frame = self.bounds;
    [self.layer addSublayer:titleLayer];
    [titleLayer setNeedsDisplay];
    
    knobButton = [[KnobButton alloc] initWithFrame:CGRectMake(1, 1, self.bounds.size.width/2-2, self.bounds.size.height-2)];
    [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
    [knobButton setTitle:titleOff forState:UIControlStateNormal];
    [self addSubview:knobButton];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [knobButton addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    
    
}
-(void)drawRect:(CGRect)rect{
    
    [self drawInnerShadowInRect:rect fillColor:self.fillColor];
    
}
#pragma mark -
#pragma mark UIGestureRecognizer
-(void) handleTap: (UITapGestureRecognizer *) sender {
    if(CGRectContainsPoint(knobButton.frame,[sender locationInView:self]) !=YES){
        CGRect frm =knobButton.frame;
        frm.origin.x += frm.size.width;
        [self valueChange];
        [titleLayer setNeedsDisplay];
        
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
    }
}
- (void)handlePan:(UIPanGestureRecognizer *)sender {
    
    if (sender.state ==  UIGestureRecognizerStateChanged) {
        CGPoint position = [sender translationInView:self];
        CGPoint center = CGPointMake(sender.view.center.x + position.x, sender.view.center.y);
        
        // Don't move the knob out of the view
        if (center.x  < self.bounds.size.width/2 + knobButton.frame.size.width/2 &&  center.x > knobButton.frame.size.width/2) {
            sender.view.center = center;
            [sender setTranslation:CGPointZero inView:self];
            titleLayer.onString = @"";
            titleLayer.offString = @"";
            [ titleLayer setNeedsDisplay];
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        CGFloat toggleCenter = CGRectGetMidX(knobButton.frame);
		[self setOn:(toggleCenter > CGRectGetMidX(self.bounds)) animated:YES];
    }
    
}

- (void)valueChange
{
    NSLog(@"value@%d",on);
    if (on) {
        knobButton.frame = knobFrameOff;
        on = !on;
        self.fillColor = ZTBLUE;
        [self setNeedsDisplay];
        [knobButton setTitle:self.titleOff forState:UIControlStateNormal];
        [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
    }else{
        knobButton.frame = knobFrameOn;
        on = !on;
        self.fillColor = ZTGRAY;
        [self setNeedsDisplay];
        [knobButton setTitle:self.titleOn forState:UIControlStateNormal];
        [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark setter
- (void)setOn:(BOOL)aOn
{
	[self setOn:aOn animated:NO];
}
- (void)setOn:(BOOL)anewon animated:(BOOL)animated
{
	BOOL previousOn = self.on;
	on = anewon;
    titleLayer.onString = self.titleOn;
    titleLayer.offString = self.titleOff;
    [titleLayer setNeedsDisplay];
	[CATransaction setAnimationDuration:0.01];
    
	[CATransaction setCompletionBlock:^{
		[CATransaction begin];
		if (!animated)
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
		else
			[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
        
        
        
		if (self.on)
		{
            self.fillColor = ZTBLUE;
			knobButton.frame = knobFrameOn;
            [knobButton setTitle:self.titleOn forState:UIControlStateNormal];
            [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
		}
		else
		{
            self.fillColor = ZTGRAY;
			knobButton.frame = knobFrameOff;
            [knobButton setTitle:self.titleOff forState:UIControlStateNormal];
            [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
		}
        
        
		[CATransaction setCompletionBlock:^{
			if (previousOn != on )
				[self sendActionsForControlEvents:UIControlEventValueChanged];
		}];
        
		[CATransaction commit];
	}];
}
- (void)setTitleOn:(NSString *)atitleOn
{
	if (atitleOn != titleOn)
	{
		titleOn = [atitleOn copy];
		titleLayer.onString = titleOn;
		[titleLayer setNeedsDisplay];
        [knobButton setTitle:self.titleOn forState:UIControlStateNormal];
        [knobButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	}
}

- (void)setTitleOff:(NSString *)atitleOff
{
	if (atitleOff != titleOff)
	{
		titleOff = [atitleOff copy];
		titleLayer.offString = titleOff;
		[titleLayer setNeedsDisplay];
        [knobButton setTitle:self.titleOff forState:UIControlStateNormal];
        [knobButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	}
}
-(void)setKnobColor:(UIColor *)aknobColor
{
    knobColor =aknobColor;
    knobButton.fillColor = knobColor;
}
-(void)setFillColor:(UIColor *)afillColor
{
    fillColor =afillColor;
    [self setNeedsDisplay];    
}

@end
