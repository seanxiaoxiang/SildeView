//
//  ScrollTabViewController.m
//  SlideView
//
//  Created by admin on 13-7-30.
//  Copyright (c) 2013年 wesleyxiao. All rights reserved.
//

#import "ScrollTabViewController.h"
#import "UIView+UIView_FindAndResignFirstResponder.h"
#import "MyViewController.h"

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
    
    //初始化viewcontrollers
    for (int i=0; i<5; i++) {
        MyViewController * view=[[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil];
        viewController[i]=view;
        view.labelView.text=[NSString stringWithFormat:@"%d",i];
    }
    

    
    self.topName=[[NSMutableArray alloc]initWithObjects:@"第一个",@"第二个",@"第三个",@"第四个",@"第五个", nil];
    
    self.contentScrollView.delegate=self;
    //监听content 的offset改变
    [self.contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    //不显示滚动条
    self.contentScrollView.showsHorizontalScrollIndicator=NO;
    self.contentScrollView.showsVerticalScrollIndicator=NO;
    self.contentScrollView.pagingEnabled=YES;
    self.contentScrollView.scrollsToTop=NO;
    self.contentScrollView.backgroundColor=[UIColor grayColor];
    
    //配置UI
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.contentScrollView) {
        // 滚动的时候，加载三个ViewController，包括左右的预加载
        [self loadViewControllers];
        
        // 因为发生了切换，所以应当resign first responder
        [self.view findAndResignFirstResponder];
    }
}

#pragma mark KVO Protocol
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.contentScrollView)
    {
        [self swithTopButton];
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
    self.topScrollView.contentSize=CGSizeMake(self.topName.count*buttonWidth, self.topScrollView.frame.size.height);
    
    
    self.topButton=[[NSMutableArray alloc]initWithCapacity:self.topName.count];
    
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
      
        [btn addTarget:self action:@selector(topButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
    }
}

-(void) configContentScrollView
{
    // 设置content scroll view的正文 大小为  name的个数乘以 scrollview本来的宽度
    self.contentScrollView.contentSize=CGSizeMake(self.topName.count* CONTENT_SCROLL_WIDTH, self.contentScrollView.contentSize.height);
    
    [self loadViewControllers];
    
}
#pragma mark -top button 按钮被按下
-(void)   topButtonDidPressed :(UIButton *) sender
{
    //发生切换，resign first responder
    [self.view findAndResignFirstResponder];
    
    // 这里会触发ScrollView的Delegate，而不触发KVO回调，因此不会影响上方按钮移动的动画
    [self.contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    CGPoint p=CGPointMake(sender.tag * CONTENT_SCROLL_WIDTH, 0);
    self.contentScrollView.contentOffset=p;
    [self.contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self swithTopButton];
    [self loadViewControllers];
}

#pragma mark - top button的切换与字体的改变
-(void)swithTopButton
{
    CGRect frame=self.selectIndicator.frame;
    //转换的时候先和 scroll width相除，再进行比较，使之得到的是一些固定的值
    frame.origin.x=(self.contentScrollView.contentOffset.x  / CONTENT_SCROLL_WIDTH ) * buttonWidth;
    self.selectIndicator.frame=frame;
       
    CGFloat offsetX;

    // 往右滚
    if (CGRectGetMaxX(frame) >= CGRectGetMaxX(self.topScrollView.bounds)){
        //滑动到尽头
        if (CGRectGetMaxX(frame) > self.topScrollView.contentSize.width) {
            offsetX=self.topScrollView.contentSize.width-self.topScrollView.bounds.size.width;
        }
        else{
            offsetX=CGRectGetMaxX(frame) -self.topScrollView.bounds.size.width;
        }
        self.topScrollView.contentOffset=CGPointMake(offsetX, 0);
    }
    else if (CGRectGetMinX(frame) <= CGRectGetMinX(self.topScrollView.bounds) )
    {
        offsetX=CGRectGetMinX(frame);
        if (offsetX <0 ) {
            offsetX=0;
        }
        self.topScrollView.contentOffset=CGPointMake(offsetX, 0);
    }
    
    [self refleshButtonTitile];
}


-(void)refleshButtonTitile
{
    // top按钮文字颜色变灰色
    NSInteger forwardContentIndex = (int)floorf((self.contentScrollView.contentOffset.x / CONTENT_SCROLL_WIDTH)+0.5);
   
    // 改变top按钮文字的颜色
    if (self.topButton.count <= forwardContentIndex) {
        return;
    }
    UIButton *currentButton = self.topButton[forwardContentIndex];
    for (UIButton *aButton in self.topButton) {
        if (aButton != currentButton) {
            [aButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal] ;
        }
    }
    [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark -顶端tab 事件响应
-(void)topTabDidPressed:(UIButton *) sender
{
    [self swithTopButton];
}

#pragma mark -加载viewcontroller

// 加载某一个viewcontroller
-(void) initTheViewControllerAtIndex:(NSInteger)index
{
    UIViewController * vc=    viewController[index];
 
    [self.contentScrollView addSubview:vc.view];
    CGRect frame=vc.view.frame;
    frame.origin.x=index * CONTENT_SCROLL_WIDTH;
    frame.size.height=self.contentScrollView.bounds.size.height;
    vc.view.frame=frame;
    
    if ([vc.view isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *)vc.view).scrollsToTop = NO;
    }
}

//加载所有的viewcontroller
-(void) loadViewControllers
{
    
    if (self.topName.count<=0) {
        return;
    }
    NSInteger forwardContentIndex = (int)floorf((self.contentScrollView.contentOffset.x / CONTENT_SCROLL_WIDTH)+0.5);

    
    if(forwardContentIndex <0){
        forwardContentIndex=0;
    }
    else if(forwardContentIndex > self.topName.count-1){
        forwardContentIndex=self.topName.count-1;
    }

    // call the method which subclass may override
    [self vcDidLoadAtIndex:forwardContentIndex];

    // 初始化（如果需要的话）
//    if (!viewController[forwardContentIndex]) {
        [self initTheViewControllerAtIndex:forwardContentIndex];
        
//    }

    if (forwardContentIndex-1 >= 0) {
        [self initTheViewControllerAtIndex:forwardContentIndex-1];
    }

    if ( forwardContentIndex+1 < self.topName.count) {
        [self initTheViewControllerAtIndex:forwardContentIndex+1];
    }
    
    
    // 初始化完了之后
    // 禁止其他的gridview的 scrollsToTop， 只允许当前这个
    
  
     for (int i = 0; i < self.topName.count; i++) {
        // 只允许当前的
        if ([viewController[i].view isKindOfClass:[UIScrollView class]]) {
            if (i == forwardContentIndex) {
                [(UIScrollView *)viewController[i].view setScrollsToTop:YES];
            }else{
                [(UIScrollView *)viewController[i].view setScrollsToTop:NO];
            }
        }
        
        // 不是当前显示的，调用viewDidDisappear
        if (i != forwardContentIndex) {
            [viewController[i] viewDidDisappear:YES];
        }else{
            // 当前的vc，则调用我自定义的myViewDidAppear
            if ([viewController[forwardContentIndex] respondsToSelector:@selector(myViewDidAppear:)]){
                [viewController[forwardContentIndex] performSelector:@selector(myViewDidAppear:) withObject:[NSNumber numberWithBool:YES]];
            }
        }
    }
    
      /**/
}


// SUBCLASS OVERRIDE
- (void)vcDidLoadAtIndex:(NSInteger)index{
    // Subclass will override this
}
@end
