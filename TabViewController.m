//
//  TabViewController.m
//  SlideView
//
//  Created by admin on 13-7-30.
//  Copyright (c) 2013年 wesleyxiao. All rights reserved.
//

#import "TabViewController.h"
#import "Content1ViewController.h"
#import "Content2ViewController.h"
#import "ScrollTabViewController.h"

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
    [self configViewController:0];
    
    
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
    NSInteger  index=[self.buttonArray indexOfObject:sender];
    [self configViewController:index];
    
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

//配置当前content view
-(void) configViewController:(NSInteger) index
{
    switch (index) {
        case 0:
        {
            Content1ViewController * newVC=[[Content1ViewController alloc]initWithNibName:@"Content1ViewController" bundle:nil];
            [self.contentView addSubview:newVC.view];
            newVC.view.frame=self.contentView.bounds;
            subViewControllers[index]=newVC;
            NSLog(@"0");
            break;
        }
        case 1:
        {
            Content1ViewController * newVC=[[Content1ViewController alloc]initWithNibName:@"Content1ViewController" bundle:nil];
            [self.contentView addSubview:newVC.view];
            newVC.view.frame=self.contentView.bounds;
            subViewControllers[index]=newVC;
            NSLog(@"1");
            break;
        }
        case 2:
        {
            ScrollTabViewController * newVC=[[ScrollTabViewController alloc]initWithNibName:@"ScrollTabViewController" bundle:nil];
            [self.contentView addSubview:newVC.view];
            newVC.view.frame=self.contentView.bounds;
            subViewControllers[index]=newVC;
            NSLog(@"2");
            break;
        }
        case 3:
        {
            Content2ViewController * newVC=[[Content2ViewController alloc]initWithNibName:@"Content2ViewController" bundle:nil];
            [self.contentView addSubview:newVC.view];
            
            newVC.view.frame=self.contentView.bounds;
            subViewControllers[index]=newVC;
            NSLog(@"3");
            break;
        }
            
        default:
            break;
    }
}
@end
