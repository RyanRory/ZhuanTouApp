//
//  SimplerSwitch.h
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

#import <Foundation/Foundation.h>
#import "KnobButton.h"
#import <QuartzCore/QuartzCore.h>

typedef void (^SetValueBlock) (BOOL flag);

@interface SimpleSwitch : UIControl<UIGestureRecognizerDelegate>
{
    KnobButton *knobButton;
    CGRect knobFrameOn;
    CGRect knobFrameOff;
    BOOL on;
    UIColor *knobColor;
    UIColor *fillColor;
}


@property(assign,nonatomic) BOOL on;
@property(retain,nonatomic) UIColor *knobColor;
@property(retain,nonatomic) UIColor *fillColor;
@property(retain,nonatomic) UIColor *onColor;
@property(strong, nonatomic) SetValueBlock block;
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
