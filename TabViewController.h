//
//  TabViewController.h
//  SlideView
//
//  Created by admin on 13-7-30.
//  Copyright (c) 2013年 wesleyxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewController : UIViewController
{
    UIViewController * subViewControllers[4];
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *tabView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;
- (IBAction)tabOnClicked:(UIButton *)sender;

@end
