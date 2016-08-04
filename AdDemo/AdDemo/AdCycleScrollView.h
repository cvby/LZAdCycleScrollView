//
//  AdCycleScrollView.h
//  AdDemo
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 李政. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdCycleScrollViewDelegate <NSObject>

@optional
-(void)AdCycleScrollViewClick:(NSInteger)index;
-(void)AdCycleScrollViewScroll:(NSInteger)index;

@end

@interface AdCycleScrollView : UIScrollView<UIScrollViewDelegate>

@property (strong,nonatomic) NSArray * imageLinkURL;
@property (strong,nonatomic) NSArray * adTitleArray;
@property (weak,nonatomic) id<AdCycleScrollViewDelegate> addelegate;

@property (strong,nonatomic) UIPageControl * pageControl;

- (void)addImageLinkURL:(NSArray *)imageLinkURL;
- (void)addImageLinkURL:(NSArray *)imageLinkURL placeHoderImageName:(NSString *)imageName;

@end
