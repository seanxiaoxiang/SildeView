//
//  UIView+UIView_FindAndResignFirstResponder.h
//  SlideView
//
//  Created by admin on 13-7-31.
//  Copyright (c) 2013年 wesleyxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_FindAndResignFirstResponder)
//view在它的subviews及自己中查找第一响应者，然后去除第一响应者
-(BOOL) findAndResignFirstResponder;
@end
