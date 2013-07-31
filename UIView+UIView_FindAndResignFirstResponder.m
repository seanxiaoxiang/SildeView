//
//  UIView+UIView_FindAndResignFirstResponder.m
//  SlideView
//
//  Created by admin on 13-7-31.
//  Copyright (c) 2013年 wesleyxiao. All rights reserved.
//

#import "UIView+UIView_FindAndResignFirstResponder.h"

@implementation UIView (UIView_FindAndResignFirstResponder)
//view在它的subviews及自己中查找第一响应者，然后去除第一响应者
-(BOOL) findAndResignFirstResponder
{
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView * subView in self.subviews) {
        if ([subView findAndResignFirstResponder]) {
            return YES;
        }
    }
    return NO;
}
@end
