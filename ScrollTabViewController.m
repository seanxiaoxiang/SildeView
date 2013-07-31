//
//  ScrollTabViewController.m
//  SlideView
//
//  Created by admin on 13-7-30.
//  Copyright (c) 2013年 wesleyxiao. All rights reserved.
//

#import "ScrollTabViewController.h"
#import "UIView+UIView_FindAndResignFirstResponder.h"

@interface ScrollTabViewController ()
{
    CGFloat buttonWidth;    //button的宽度
}

@end

#define CONTENT_SCROLL_WIDTH self.contentScrollView.bounds.size.width

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
//    self.contentScrollView.scrollsToTop=NO;
    
    self.topName=[[NSMutableArray alloc]initWithObjects:@"第一个",@"第二个",@"第三个",@"第四个",@"第五个", nil];
    
    
    self.contentScrollView.delegate=self;
    //监听content 的offset改变
    [self.contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    //不显示滚动条
    self.contentScrollView.showsHorizontalScrollIndicator=YES;
    self.contentScrollView.showsVerticalScrollIndicator=YES;
    self.contentScrollView.pagingEnabled=YES;
    self.contentScrollView.scrollsToTop=NO;
//    self.contentScrollView.contentSize=CGSizeMake(500, 600);
    
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


#pragma mark KVO Protocol
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.contentScrollView)
    {
        [self swithTopButton];
//        NSLog(@"x:%f",frame.origin.x);
    }
}

#pragma mark -Config UI

-(void)configUI
{
    [self configTabScrollView];
    [self configContentScrollView];
}
-(void)configTabScrollView
{
    //设置topbutton 的宽度
    buttonWidth=self.topScrollView.frame.size.width/(self.topName.count == 0? 1: self.topName.count);
    
    if (buttonWidth<MAX_BUTTON_WIDTH) {
        buttonWidth=MAX_BUTTON_WIDTH;
    }
    
    self.selectIndicator.frame=CGRectMake(0, 0, buttonWidth, self.selectIndicator.bounds.size.height);
    
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
      
        btn.tag=i;
    }
}

-(void) configContentScrollView
{
    // 设置content scroll view的正文 大小为  name的个数乘以 scrollview本来的宽度 
    self.contentScrollView.contentSize=CGSizeMake(self.topName.count* CONTENT_SCROLL_WIDTH, self.contentScrollView.contentSize.height);
   
}
#pragma mark -top button 按钮被按下
-(void) topButtonDidPressed:(UIButton *) sender
{
    //发生切换，resign first responder
    [self.view findAndResignFirstResponder];
}

#pragma mark - top button的切换
-(void)swithTopButton
{
    CGRect frame=self.selectIndicator.frame;
    frame.origin.x=(self.contentScrollView.contentOffset.x  / CONTENT_SCROLL_WIDTH ) * buttonWidth;
    self.selectIndicator.frame=frame;
}

@end
