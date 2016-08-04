//
//  CBDProgressView.m
//  CarBaDa
//
//  Created by admin on 16/6/28.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "CBDProgressView.h"

#define ProgressRadius 3.0

@interface CBDProgressView()

@property (nonatomic,strong)CALayer *progressLayer;

@end

@implementation CBDProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor grayColor]];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:ProgressRadius];
        //防止万一，不脱离边界
        self.clipsToBounds = YES;
        
        self.progressLayer = [CALayer layer];
        self.progressLayer.frame =CGRectMake(0,0,0, frame.size.height);
        self.progressLayer.backgroundColor = [UIColor cyanColor].CGColor;
        [self.progressLayer setMasksToBounds:YES];
        [self.progressLayer setCornerRadius:ProgressRadius];
        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}

-(void)setProgress:(float)progress{
    _progress=progress;
    NSLog(@"%f",self.frame.size.width);
    self.progressLayer.frame =CGRectMake(0,0,self.frame.size.width *progress,self.frame.size.height);
}

@end
