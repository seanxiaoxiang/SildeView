//
//  ScrollTabViewController.m
//  SlideView
//
//  Created by admin on 13-7-30.
//  Copyright (c) 2013年 wesleyxiao. All rights reserved.
//

#import "ScrollTabViewController.h"

@interface ScrollTabViewController ()
{
    CGFloat buttonWidth;    //button的宽度
}

@end

@implementation ScrollTabViewController
@synthesize topButton,topName;

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
    self.contentScrollView.delegate=self;
//    self.contentScrollView.scrollsToTop=NO;
    
    self.topName=[[NSMutableArray alloc]initWithObjects:@"第一个",@"第二个",@"第三个",@"第四个",@"第五个", nil];
    
    //监听content 的offset改变
    [self.contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    //不显示滚动条
    self.contentScrollView.showsHorizontalScrollIndicator=NO;
    self.contentScrollView.showsVerticalScrollIndicator=NO;
    
    [self.contentScrollView setContentSize:CGSizeMake(500, 0)];
    
    [self configUI];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTopScrollView:nil];
    [self setContentScrollView:nil];
    [self setSelectIndicator:nil];
    [super viewDidUnload];
}

#pragma mark -UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
}

#pragma mark KVO Protocol
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.contentScrollView)
    {
        NSLog(@"scrolled");
    }
}

#pragma mark -Config UI

-(void)configUI
{
    [self configTabScrollView];
}
-(void)configTabScrollView
{
    //设置topbutton 的宽度
    buttonWidth=self.topScrollView.frame.size.width/(self.topName.count == 0? 1: self.topName.count);
    
    if (buttonWidth<MAX_BUTTON_WIDTH) {
        buttonWidth=MAX_BUTTON_WIDTH;
    }
    
    self.selectIndicator.bounds=CGRectMake(0, 0, buttonWidth, self.selectIndicator.bounds.size.height);
    
    //设置top scroll 的大小 宽度为topname数量乘以buttonwidth，高度为topscrollviewb本身高度
    self.contentScrollView.contentSize=CGSizeMake(self.topName.count*buttonWidth, self.topScrollView.frame.size.height);
    
    //为每个topname新添加一个button
    for (int i=0; i<self.topName.count; i++) {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        NSString * titile=[self.topName objectAtIndex:i];
        [btn setTitle:titile forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [self.topButton addObject:btn];
        
        [self.topScrollView addSubview:btn];
        btn.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, self.topScrollView.frame.size.height);
        if (i==0) {
            NSLog(@"%f",self.selectIndicator.frame.origin.x);
        }
        btn.tag=i;
        
    }
    
}
@end
