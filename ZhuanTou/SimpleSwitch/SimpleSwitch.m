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

@interface SimpleSwitch()
-(void)setUpWithDefault;
@end

@implementation SimpleSwitch
@synthesize on;
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
   
    self.fillColor = ZTGRAY;
    self.knobColor = [UIColor whiteColor];
   
    on= NO;
    
    knobButton = [[KnobButton alloc] initWithFrame:CGRectMake(1, 1, self.bounds.size.width/2-2, self.bounds.size.height-2)];
    [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
    [knobButton setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:knobButton];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [knobButton addGestureRecognizer:panGesture];
    [knobButton addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    
    
}
-(void)drawRect:(CGRect)rect{
    
    [self drawInnerShadowInRect:rect fillColor:self.fillColor];
    
}
#pragma mark -
#pragma mark UIGestureRecognizer
- (void)change:(id)sender
{
    [self valueChange];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) handleTap: (UITapGestureRecognizer *) sender {
    if(CGRectContainsPoint(knobButton.frame,[sender locationInView:self]) !=YES){
        CGRect frm =knobButton.frame;
        frm.origin.x += frm.size.width;
        [self valueChange];
        
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
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        CGFloat toggleCenter = CGRectGetMidX(knobButton.frame);
		[self setOn:(toggleCenter > CGRectGetMidX(self.bounds)) animated:YES];
    }
    
}

- (void)valueChange
{
    if (on) {
        knobButton.frame = knobFrameOff;
        on = !on;
        self.fillColor = ZTGRAY;
        [self setNeedsDisplay];
        [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
    }else{
        knobButton.frame = knobFrameOn;
        on = !on;
        self.fillColor = self.onColor;
        [self setNeedsDisplay];
        [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
    }
    if (self.block)
    {
        self.block(on);
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
	[CATransaction setAnimationDuration:0.01];
    
	[CATransaction setCompletionBlock:^{
		[CATransaction begin];
		if (!animated)
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
		else
			[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
        
        
        
		if (self.on)
		{
            self.fillColor = self.onColor;
			knobButton.frame = knobFrameOn;
            [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
		}
		else
		{
            self.fillColor = ZTGRAY;
			knobButton.frame = knobFrameOff;
            [knobButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:181.0/255.0 blue:44.0/255.0 alpha:100] forState:UIControlStateNormal];
		}
        
        
		[CATransaction setCompletionBlock:^{
			if (previousOn != on )
				[self sendActionsForControlEvents:UIControlEventValueChanged];
		}];
        
		[CATransaction commit];
	}];
    
    if (self.block)
    {
        self.block(on);
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
