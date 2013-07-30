//
//  ScrollTabViewController.h
//  SlideView
//
//  Created by admin on 13-7-30.
//  Copyright (c) 2013年 wesleyxiao. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MAX_CONTROLS_NUMBER 100
#define MAX_BUTTON_WIDTH 71
@interface ScrollTabViewController : UIViewController<UIScrollViewDelegate>
{
    UIViewController * viewController[MAX_CONTROLS_NUMBER];
}
@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIView *selectIndicator;
@property (strong, nonatomic) NSMutableArray * topButton;   //顶端的tab按钮
@property (strong, nonatomic) NSMutableArray * topName; //tab按钮的名字

@end
