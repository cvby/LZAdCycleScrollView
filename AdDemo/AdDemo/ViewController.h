//
//  ViewController.h
//  AdDemo
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 李政. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdCycleScrollView.h"

@interface ViewController : UIViewController<AdCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet AdCycleScrollView *AdScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

