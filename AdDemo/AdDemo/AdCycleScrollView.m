//
//  AdCycleScrollView.m
//  AdDemo
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 李政. All rights reserved.
//

#import "AdCycleScrollView.h"
#import "UIImageView+CBDWebImage.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] applicationFrame].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
//广告的宽度
#define kAdViewWidth  self.bounds.size.width
//广告的高度
#define kAdViewHeight  self.bounds.size.height

@interface AdCycleScrollView (){
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    
    BOOL isTimeUp;
}

@property (nonatomic,assign) NSUInteger centerImageIndex;
@property (nonatomic,assign) NSUInteger leftImageIndex;
@property (nonatomic,assign) NSUInteger rightImageIndex;
@property (assign,nonatomic) NSTimer *moveTimer;
@property (strong,nonatomic) NSString *sPlaceImageName;

@end

@implementation AdCycleScrollView

@synthesize centerImageIndex;
@synthesize rightImageIndex;
@synthesize leftImageIndex;
@synthesize moveTimer;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCreateView];
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initCreateView];
    [self setupMainView];
}

-(void)initCreateView{
    self.delegate = self;
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    self.contentSize = CGSizeMake(SCREEN_WIDTH * 3, kAdViewHeight);
}
// 设置显示图片的collectionView
- (void)setupMainView
{
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kAdViewHeight)];
    [self addSubview:_leftImageView];
    
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, kAdViewHeight)];
    _centerImageView.userInteractionEnabled = YES;
    [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    [self addSubview:_centerImageView];
    
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, kAdViewHeight)];
    [self addSubview:_rightImageView];
}

//这个方法会在子视图添加到父视图或者离开父视图时调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    //解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
    if (!newSuperview)
    {
        [self.moveTimer invalidate];
        moveTimer = nil;
    }
    else
    {
        [self setUpTime];
    }
}

- (void)setUpTime
{
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animalMoveImage:) userInfo:nil repeats:YES];
    isTimeUp = NO;
}

- (void)addImageLinkURL:(NSArray *)imageLinkURL
{
    [self addImageLinkURL:imageLinkURL placeHoderImageName:nil];
}

- (void)addImageLinkURL:(NSArray *)imageLinkURL placeHoderImageName:(NSString *)imageName
{
    self.sPlaceImageName=imageName;
    [self setImageLinkURL:imageLinkURL];
}

#pragma mark - 设置广告所使用的图片(名字)
- (void)setImageLinkURL:(NSArray *)imageLinkURL
{
    _imageLinkURL = imageLinkURL;
    leftImageIndex = imageLinkURL.count-1;
    centerImageIndex = 0;
    rightImageIndex = 1;
    
    if (imageLinkURL.count==1)
    {
        self.scrollEnabled = NO;
        rightImageIndex = 0;
    }
    self.pageControl.numberOfPages = _imageLinkURL.count;
    self.pageControl.currentPage = 0;
    
    [_leftImageView cbd_setImageWithURL:imageLinkURL[leftImageIndex] placeholder:self.sPlaceImageName completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        //
    }];
    [_centerImageView cbd_setImageWithURL:imageLinkURL[centerImageIndex] placeholder:self.sPlaceImageName completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        //
    }];
    [_rightImageView cbd_setImageWithURL:imageLinkURL[rightImageIndex] placeholder:self.sPlaceImageName completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        //
    }];
}

#pragma mark - 创建pageControl,指定其显示样式

-(UIPageControl*)pageControl{
    if(!_pageControl)
    {
        _pageControl=[[UIPageControl alloc] init];
    }
    return _pageControl;
}

#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage:(NSTimer *)time
{
    [self setContentOffset:CGPointMake(kAdViewWidth * 2, 0) animated:YES];
    isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidScroll:) userInfo:nil repeats:NO];
}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",self.contentOffset.x);
    if (self.contentOffset.x <= 0)
    {
        centerImageIndex = centerImageIndex - 1;
        leftImageIndex = leftImageIndex - 1;
        rightImageIndex = rightImageIndex - 1;
        
        if (leftImageIndex == -1) {
            leftImageIndex = _imageLinkURL.count-1;
        }
        if (centerImageIndex == -1)
        {
            centerImageIndex = _imageLinkURL.count-1;
        }
        if (rightImageIndex == -1)
        {
            rightImageIndex = _imageLinkURL.count-1;
        }
        if(self.addelegate&&[self.addelegate respondsToSelector:@selector(AdCycleScrollViewScroll:)])
        {
            [self.addelegate AdCycleScrollViewScroll:centerImageIndex];
        }
    }
    else if(self.contentOffset.x >= kAdViewWidth * 2)
    {
        centerImageIndex = centerImageIndex + 1;
        leftImageIndex = leftImageIndex + 1;
        rightImageIndex = rightImageIndex + 1;
        
        if (leftImageIndex == _imageLinkURL.count) {
            leftImageIndex = 0;
        }
        if (centerImageIndex == _imageLinkURL.count)
        {
            centerImageIndex = 0;
        }
        if (rightImageIndex == _imageLinkURL.count)
        {
            rightImageIndex = 0;
        }
        if(self.addelegate&&[self.addelegate respondsToSelector:@selector(AdCycleScrollViewScroll:)])
        {
            [self.addelegate AdCycleScrollViewScroll:centerImageIndex];
        }
    }
    else
    {
        return;
    }
    
    //换成YY
    [_leftImageView cbd_setImageWithURL:_imageLinkURL[leftImageIndex] placeholder:self.sPlaceImageName completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        //
    }];
    [_centerImageView cbd_setImageWithURL:_imageLinkURL[centerImageIndex] placeholder:self.sPlaceImageName completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        //
    }];
    [_rightImageView cbd_setImageWithURL:_imageLinkURL[rightImageIndex] placeholder:self.sPlaceImageName completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        //
    }];
    _pageControl.currentPage = centerImageIndex;
    
    self.contentOffset = CGPointMake(kAdViewWidth, 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!isTimeUp) {
        [moveTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
    }
    isTimeUp = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [moveTimer invalidate];
    moveTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setUpTime];
}

/**
 *
 *  @brief  当前显示的图片被点击
 */
-(void)tap
{
    NSLog(@"11");
    if(self.addelegate&&[self.addelegate respondsToSelector:@selector(AdCycleScrollViewClick:)])
    {
        [self.addelegate AdCycleScrollViewClick:centerImageIndex];
    }
}
@end
