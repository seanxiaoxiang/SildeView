//
//  TabViewController.m
//  SlideView
//
//  Created by admin on 13-7-30.
//  Copyright (c) 2013年 wesleyxiao. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [self setTabView:nil];
    [self setArrowImage:nil];
    [self setButtonArray:nil];
    [super viewDidUnload];
}
- (IBAction)tabOnClicked:(UIButton *)sender {
    for (UIButton * btn in self.buttonArray) {
        btn.selected=NO;
    }
    sender.selected=YES;
    
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect newFrame=self.arrowImage.frame;
        newFrame.origin.x=sender.frame.origin.x;
        self.arrowImage.frame=newFrame;
    } completion:^(BOOL finished) {
    }];
}
@end
